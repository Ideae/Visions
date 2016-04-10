run('../vlfeat-0.9.20/toolbox/vl_setup')
load('pos_neg_feats.mat')

feats = cat(1,pos_feats,neg_feats);
labels = cat(1,ones(pos_nImages,1),-1*ones(neg_nImages,1));

lambda = 0.01;
[w,b] = vl_svmtrain(feats',labels',lambda);

fprintf('Classifier performance on train data:\n')
confidences = [pos_feats; neg_feats]*w + b;

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);

load('pos_neg_feats_validation.mat')
fprintf('Classifier performance on validation data:\n')
labels_valid = cat(1,ones(pos_nImages_valid,1),-1*ones(neg_nImages_valid,1));
confidences_valid = [pos_feats_valid; neg_feats_valid]*w + b;
[tp_rate_valid, fp_rate_valid, tn_rate_valid, fn_rate_valid] =  report_accuracy(confidences_valid, labels_valid);

save('my_svm.mat', 'w', 'b');