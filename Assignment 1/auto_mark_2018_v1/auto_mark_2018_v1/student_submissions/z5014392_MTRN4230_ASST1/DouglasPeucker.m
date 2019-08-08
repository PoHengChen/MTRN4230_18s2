function result = DouglasPeucker(Points,epsilon)
    dmax = 0;
    edx = length(Points);
    for ii = 2:edx-1
        d = penDistance(Points(:,ii),Points(:,1),Points(:,edx));
        if d > dmax
            idx = ii;
            dmax = d;
        end
    end

    if dmax > epsilon
        % recursive call
        recResult1 = DouglasPeucker(Points(:,1:idx),epsilon);
        recResult2 = DouglasPeucker(Points(:,idx:edx),epsilon);
        result = [recResult1(:,1:length(recResult1)-1) recResult2(:,1:length(recResult2))];
    else
        result = [Points(:,1) Points(:,edx)];
    end
    
    % === filter close result ===
    min_dist = 2*sqrt(2);
    temp=[];
    result = [result(:,end),result];
    for i = 2:size(result,2)
        dist = sqrt((result(1,i)-result(1,i-1))^2 + (result(2,i)-result(2,i-1))^2);
        if dist > min_dist
            if isempty(temp)
                temp = result(:,i);
            else
                temp = [temp,result(:,i)];
            end
        end
    end
    result = temp;
    
    % If max distance is greater than epsilon, recursively simplify
    function d = penDistance(Pp, P1, P2)
        % find the distance between a Point Pp and a line segment between P1, P2.
        d = abs((P2(2,1)-P1(2,1))*Pp(1,1) - (P2(1,1)-P1(1,1))*Pp(2,1) + P2(1,1)*P1(2,1) - P2(2,1)*P1(1,1)) ...
            / sqrt((P2(2,1)-P1(2,1))^2 + (P2(1,1)-P1(1,1))^2);
    end
end