function [fixed_pts, matching_pts] = extract_ptCloud_features(ptCloud_before, ptCloud_after)

before_features = extractFPFHFeatures(ptCloud_before);
after_features  = extractFPFHFeatures(ptCloud_after);

[matched_pairs, scores] = pcmatchfeatures(before_features, after_features, ...
    ptCloud_before, ptCloud_after, "Method", "Exhaustive");

fixed_pts       = select(ptCloud_before, matched_pairs(:,1));
matching_pts    = select(ptCloud_after, matched_pairs(:,2));

end