function [ptCloud_before, ptCloud_after] = reshape_ptClouds(ptCloud_before, ptCloud_after)

% Reshape location to Mx3 array and delete missing values
A1 = ptCloud_before.Location;
C1 = reshape(A1, ptCloud_before.Count, 3);
C1 = rmmissing(C1);

A2 = ptCloud_after.Location;
C2 = reshape(A2, ptCloud_after.Count, 3);
C2 = rmmissing(C2);

% Make arrays same size
pts_dif = abs(length(C1) - length(C2));
if length(C1) > length(C2)
    C1 = C1(1:end-pts_dif,:);
else
    C2 = C2(1:end-pts_dif,:);
end

ptCloud_before  = pointCloud(C1);
ptCloud_after   = pointCloud(C2);

end