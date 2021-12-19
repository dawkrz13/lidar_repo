function ptCloud = preprocess_ptCloud(ptCloud, cylinder_radius)

% Compute the distance between each point and the origin.
dists = hypot(ptCloud.Location(:,:,1), ptCloud.Location(:,:,2));

% Select the points inside the cylinder radius.
cylinder_idx = dists <= cylinder_radius;
ptCloud = select(ptCloud, cylinder_idx, 'OutputSize', 'full');

% Remove ground.
[~, ptCloud] = segmentGroundSMRF(ptCloud, 'ElevationThreshold', 0.05);

end