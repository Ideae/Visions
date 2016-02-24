if (false)
A = [
0 0 0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0;
0 0 0 2 1 1 3 0 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 0 3 1 1 5 0 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 0 1 1 1 1 0 0 0;
0 0 0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0;
];
fprintf('q1_1\n');
q1_1();
pause;
fprintf('q1_2\n');
q1_2();
pause;
fprintf('q1_3\n');
res_q1_3 = q1_3(A,[1,0,-1]);
printMatrix(res_q1_3);
pause;
q1_4();
pause;
q1_5();
pause;
end
q2_1();
% q2_2();
q2_3();



