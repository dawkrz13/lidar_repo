veloReader = velodyneFileReader('mov1.pcap','VLP16');

% Parameters
cylinder_radius = 6;

% Select frames
num_frame1 = 67;
num_frame2 = 344;
num_frame3 = 656;
num_frame4 = 915;
num_frame5 = 1166;
frames = [num_frame1 num_frame2 num_frame3 num_frame4 num_frame5];
%frames = [num_frame1 num_frame3];
num_frames = length(frames);

% Select and preprocess base subframe
ptCloud_base = readFrame(veloReader, num_frame1); ptCloud_base.Count
ptCloud_base = preprocess_ptCloud(ptCloud_base, cylinder_radius);

for i = frames(2:end)
    
    % Select transposed frame
    ptCloud_t = readFrame(veloReader, i);

    % Preprocess transposed frame
    ptCloud_t = preprocess_ptCloud(ptCloud_t, cylinder_radius);
    
    % Visualize base nad transposed frames
    figure; pcshowpair(ptCloud_base, ptCloud_t);
    legend("base","transposed","TextColor",[1 1 0]);
    
    % Reshape point clouds
    [ptCloud_before, ptCloud_after] = reshape_ptClouds(ptCloud_base, ptCloud_t); 
    
    % Extract point clouds features
    [fixed_pts, matching_pts] = extract_ptCloud_features(ptCloud_before, ptCloud_after);
    
    % Visualize features points
    figure; pcshowpair(fixed_pts, matching_pts); title('Feature points');
    
    % Calculate absolute orientation of the frames
    [estimated_tform, inlierIndex] = estimateGeometricTransform3D(fixed_pts.Location, ...
        matching_pts.Location, "rigid");
    [s,R,T,error] = absoluteOrientationQuaternion((fixed_pts.Location)',(matching_pts.Location'));
    [regParams,Bfit,ErrorStats] = absor((fixed_pts.Location)',(matching_pts.Location)');

    % Invert transform and compare
    est_tform = rigid3d(R',T');
    ptCloud_tformed = pctransform(ptCloud_after,invert(est_tform));
    
    figure; pcshowpair(ptCloud_before, ptCloud_tformed); title("Result");
end
