timeinstants = [10:1:150]';
stf_xe = [];
stf_eul = [];
fprintf('t=\n');
for j=1:length(timeinstants)
    plat.proceed2time( timeinstants(j) );
    
        
    stf_xe = [stf_xe, plat.getstate({'x','y','z'})];
    stf_eul = [stf_eul,   plat.getstate({'psi','theta','phi'}) ];
    
    fprintf('%f,',timeinstants(j));
    if mod( j, 20 )==0
        fprintf('\n');
    end
    
end
fprintf('\n')


figure
subplot(611)
hold on
grid on
plot( timeinstants, stf_xe(1,:))
if exist('sim_xe')
    plot( sim_xe.time, sim_xe.signals.values(:,1),'r' )
end
ylabel('x')

subplot(612)
hold on
grid on
plot( timeinstants, stf_xe(2,:))
if exist('sim_xe')
plot( sim_xe.time, sim_xe.signals.values(:,2),'r' )
end
ylabel('y')

subplot(613)
hold on
grid on
plot( timeinstants, stf_xe(3,:))
if exist('sim_xe')
plot( sim_xe.time, sim_xe.signals.values(:,3),'r' )
end
ylabel('z')

subplot(614)
hold on
grid on
plot( timeinstants, pangle( stf_eul(1,:) ))
if exist('sim_eul')
plot( sim_xe.time, pangle( sim_eul.signals.values(:,3)),'r' )
end
ylabel('\psi')

subplot(615)
hold on
grid on
plot( timeinstants, pangle( stf_eul(2,:) ) )
if exist('sim_eul')
plot( sim_xe.time, pangle( sim_eul.signals.values(:,2)),'r' )
end
ylabel('\theta')

subplot(616)
hold on
grid on
plot( timeinstants, pangle( stf_eul(3,:) ) )
if exist('sim_eul')
plot( sim_xe.time, pangle( sim_eul.signals.values(:,1) ),'r' )
end
ylabel('\phi')

figure
grid on
hold on
plot3(stf_xe(1,:), stf_xe(2,:), stf_xe(3,:),'.')
for i=1:length(timeinstants)
   text(stf_xe(1,i), stf_xe(2,i), stf_xe(3,i),num2str(timeinstants(i)) ) 
end
xlabel('x')
ylabel('y')
zlabel('z')


