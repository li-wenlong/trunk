function [x_new,P_new,w_new]= gaus_merge(x,P,w,threshold)

L= length(w); x_dim= size(x,1);
I= 1:L;
el= 1;

while ~isempty(I),
    [notused,j]= max(w); j= j(1);
    Ij= []; 
    iPt= inv(P(:,:,j));
    
    
    w_new(el)= 0; 
    x_new(:,el)= zeros(x_dim,1); P_new(:,:,el)= zeros(x_dim,x_dim);
    for i= I
        val= (x(:,i)-x(:,j))'*iPt*(x(:,i)-x(:,j));
        if val <= threshold,
            Ij= [ Ij i ];
            %w_new(el)= w_new(el)+ w(i);
            %x_new(:,el)= x_new(:,el)+ w(i)*x(:,i);
            %P_new(:,:,el)= P_new(:,:,el)+ w(i)*P(:,:,i);
        end;
    end;
    for i= Ij
        w_new(el)= w_new(el)+ w(i);
        x_new(:,el)= x_new(:,el)+ w(i)*x(:,i);
    end;
    x_new(:,el)= x_new(:,el)/w_new(el);
    for i= Ij
        P_new(:,:,el)= P_new(:,:,el)+ w(i)*( P(:,:,i)+ (x(:,i)-x_new(:,el))*(x(:,i)-x_new(:,el))' );
    end;
    P_new(:,:,el)= P_new(:,:,el)/w_new(el);
    I= setdiff(I,Ij);
    w(Ij)= -1;
    el= el+1;
end;
