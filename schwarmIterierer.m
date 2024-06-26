function [x, v] = schwarmIterierer(iterFktn, tspan, x0, v0, verlauf_speichern, fortschritt_anzeigen)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    arguments
        iterFktn
        tspan (1, 3) {mustBeNumeric}
        x0 (:, 2) {mustBeNumeric}
        v0 (:, 2) {mustBeNumeric}
        verlauf_speichern (1,1) logical = 0
        fortschritt_anzeigen (1,1) logical = 0
    end

    T_init = tspan(1);
    T_end = tspan(2);
    t_delta = tspan(3);
    iters = my_utils.time2idx(tspan, T_end)-1;

    step = int64(iters/100);
    
    mat_size = size(x0);
    if verlauf_speichern
        mat_size(3) = iters + 1;
    end
    
    x = zeros(mat_size);
    v = x;

    x(:,:,1) = x0;
    v(:,:,1) = v0;

    cond_int = int64(verlauf_speichern);
    
    lastMsgLen = 0;
    for i = 1:iters
        if fortschritt_anzeigen && mod(i, step) == 0
            fprintf(repmat('\b', 1, lastMsgLen));
            lastMsgLen = fprintf("%s", num2str((i*100)/iters) + "%");
        end
        prev_idx = (i-1) * cond_int + 1; % ist 1 wenn verlauf_speichern false ist, ansonsten i
        next_idx =    i  * cond_int + 1; % ist 1 wenn verlauf_speichern false ist, ansonsten i+1
        [x_next, v_next] = iterFktn(t_delta, x(:,:,prev_idx), v(:,:,prev_idx));
        x(:, :, next_idx) = x_next;
        v(:, :, next_idx) = v_next;
    end

    if lastMsgLen ~= 0
        fprintf("\n");
    end
end

