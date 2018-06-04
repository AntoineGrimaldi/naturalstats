function [] = waveletplot( Cmax, fine, q, n, H_vh, H_hd, H_hupper, H_vleft, H_hleft, H_dupperleft, H_hprt, H_dprt)

figure;
subplot(4, 2, 2); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_hd(:,:,q));
xlabel('diagonal component')
ylabel('horizontal component')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 1); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_vh(:,:,q)');
xlabel('vertical component')
ylabel('horizontal component')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 3); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_hupper(:,:,q)');
ylabel('horizontal component')
xlabel('upper brother')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 4); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_vleft(:,:,q)');
ylabel('vertical component')
xlabel('left brother')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 5); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_hleft(:,:,q)');
ylabel('horizontal component')
xlabel('left brother')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 6); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_dupperleft(:,:,q)');
ylabel('diagonal component')
xlabel('upper left brother')
axis(n*[-0.1 0.1 -0.1 0.1])

subplot(4, 2, 7); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_hprt(:,:,q));
ylabel('horizontal child')
xlabel('horizontal parent')
axis(n*[-0.1 0.1 -0.05 0.05])

subplot(4, 2, 8); contour([-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+1/fine:2*Cmax/fine:Cmax],[-Cmax:2*Cmax/fine:0-2*Cmax/fine 0+2*Cmax/fine:2*Cmax/fine:Cmax],H_dprt(:,:,q));
ylabel('diagonal child')
xlabel('diagonal parent')
axis(n*[-0.1 0.1 -0.05 0.05])

suptitle(strcat('Wavelet joint histograms for DR category number ', num2str(q)))
end