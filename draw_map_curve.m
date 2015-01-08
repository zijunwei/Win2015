% draw the curves of map of different lambda in Lssvm and the map of svm
% using thread or not using thread
lamda=-3:-1:-9;
map_thread_lssvm=[43.2,48.5,57.5,59.1,58.2,57.8,57.7];
map_wo_thread_lssvm=[47.3,54.2,63.0,64.2,63.8,63.8,63.8];
map_thread_svm= ones(1,7)*58.1;
map_wo_thread_svm= ones(1,7)*63.8;

figure;
hold on;
plot(lamda,map_wo_thread_svm,'r--');
plot(lamda,map_thread_svm,'g--');
plot(lamda,map_wo_thread_lssvm,'g-o');
plot(lamda,map_thread_lssvm,'b-o');
axis([-10 -2 30 80])
legend('Linear SVM w/o Thread','Linear SVM with Thread','LSSVM w/o Thread','LSSVM with Thread')
xlabel('log \lambda');
ylabel('meanAP percentage')