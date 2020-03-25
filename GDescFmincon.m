% function roverCalcPosition = GDescFmincon(params,beacons,distances)

syms f(x,y) [1 params.anchorQuantity]

for i = 1:params.anchorQuantity
    bx = beacons(i,1);
    by = beacons(i,2);
    dst= dTR(i);
    eval(['f', num2str(i), '(x,y) = (bx - x)^2 + (by - y)^2 - dst^2;']);
end
f = subs(f);
eqns(f,1,1)

% fmincon(@(f,x,y)eqns,[0,0], [],[])

function f = eqns(fun,x,y)
    f = double(fun(x,y));
end
% end

