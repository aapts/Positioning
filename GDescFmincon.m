% function roverCalcPosition = GDescFmincon(params,beacons,distances)
% function GDescFmincon
syms f(x) [1 params.anchorQuantity]

for i = 1:params.anchorQuantity
    bx = beacons(i,1);
    by = beacons(i,2);
    dst= dTR(i);
    eval(['f', num2str(i), '(x) = (bx - x(1))^2 + (by - x(2))^2 - dst^2;']);
end
f = subs(f);


% fmincon(@(x) ,[0,0], [],[])

% end

