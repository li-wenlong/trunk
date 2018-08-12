function L=multiObjLikelihood(z,x,H,R)
    %   L=multiObjLikelihood(z,x,H,R) returns the multi-object likelihood
    %   cell array L.
    %   
    %   Input variables are:
    %       z - cell array representing the set of measurements from which
    %           the multi-object likelihood is calculated.
    %       x - cell array for the particle samples.
    %       H - projection matrix, to project the state vector x onto the
    %           observation space. If x is a 4-dimensional state vector
    %           containing x,y coordinate positions and x,y velocties, then
    %           H transforms x to a 2-dimensional vector containing only
    %           x,y coordinate positions.
    %       R - noise covariance matrix which describes the spread of
    %           points for the extended object. These points will be
    %           generated along a half-ellipse with pre-specified
    %           parameters (angle, major_axis, minor_axis).
    
    L=[];
    
    %Call function
    function Sigma=vpaMat(Sigma,n)
        [row,col]=size(Sigma);
        
        for i=1:row
            for j=1:col
                Sigma(i,j)=round(10^4*Sigma(i,j))*10^-4;
            end
        end
    end
    
    %Global variable/parameter declarations
    %   The following variables/parameters may need to be pre-defined:
    %       P - the covariance matrix for the Gaussian from
    %           which the particles are sampled.
    %
    %       False alarm (Poisson) process parameters (only required if
    %       filtering in clutter):
    %       [x_min,x_max] - observation region x-axis dimensions.
    %       [y_min,y_max] - observation region y-axis dimensions.
    %              lambda - clutter rate.
    %
    %       Ellipse parameters:
    %            gamma - desired number of points on the half-ellipse.
    %            angle - angle of rotation in degrees.
    %       major_axis - length of major axis.
    %       minor_axis - length of minor axis.
    %
    %       r_sig1 - standard deviation (squared) of the Gaussian
    %                measurement noise in relation to the points on the
    %                half-ellipse
    global P
    global x_min
    global x_max
    global y_min
    global y_max
    global lambda
    
    global gamma
    global angle
    global major_axis
    global minor axis
    
    global r_sig1
    
    %Clear cell array
    nz=[];
    S=[];
    A=[];
    b=[];
    ind=[];
    
    %Set the number of measurements and particles
    nObs=length(z);
    nParticles=length(x);
    
    R_11=r_sig1*eye(2);
    R_12=sqrt(r_sig1)*eye(2)*sqrt(R);
    P_12=R_12(1)*[eye(2) eye(2)];
    
    invertR=inv(R);
    H_dash=eye(2)+R_12*invertR;
    R_Schur=R_11-R_12*invertR*R_12';
    
    invertP=inv(P);
    invertR_11=inv(R_11+R_11);
    
    
    for i=1:nParticles
        for j=1:gamma
            theta=(j/gamma)*pi-(pi/2);  %Use this equation for the side of an ellipse above the major axis,
            %theta=(i/gamma)*pi+(pi/2); %otherwise
            beta=angle*pi/180;
            x_pt=[1 0]*H*x{i}+major_axis*cos(theta)*cos(beta)-minor_axis*sin(theta)*sin(beta);
            y_pt=[0 1]*H*x{i}+major_axis*cos(theta)*sin(beta)+minor_axis*sin(theta)*cos(beta);
            ellipsePt{j}=[x_pt y_pt]';
        end
        nC_z=1;
        for j=1:nObs
            nz{j}=0;
            for k=1:gamma
                validReg=(z{j}-ellipsePt{k})'*(invertR_11)*(z{j}-ellipsePt{k});
                if validReg<=4
                    nz{j}=nz{j}+1;
                    S{j,nz{j}}=H_dash'*(R_11-P_12*invertP*P_12')*H_dash+R_Schur;
                    A{j,nz{j}}=H_dash'*P_12*invertP-R_12*invertR*H;
                    b{j,nz{j}}=H_dash*(ellipsePt{k}-P_12*invertP*x{i});
                end
            end
            if nz{j}~=0
                nC_z=nC_z*nz{j};
            else
                continue
            end
        end
    
        combNum=0;
        sumDenom=0;
        for j=1:nObs
            if nz{j}~=0
                ind{j}=1;
            else
                continue
            end
        end
        while combNum<nC_z
            cumulTotal_nC_z=1;
            mean=x{i};
            covar=P;
            denomWeight=1;
            for j=1:nObs
                if nz{j}~=0
                    cumulTotal_nC_z=cumulTotal_nC_z*nz{j};
                    if j==1
                        if gcd(nC_z/cumulTotal_nC_z,combNum)==nC_z/cumulTotal_nC_z
                            index{combNum+1,j}=(combNum/(nC_z/cumulTotal_nC_z))+1;
                        else
                            index{combNum+1,j}=index{combNum,j};
                        end
                    else
                        if gcd(nC_z/cumulTotal_nC_z,combNum)==nC_z/cumulTotal_nC_z
                            index{combNum+1,j}=ind{j};
                            if ind{j}==nz{j}
                                ind{j}=1;
                            else
                                ind{j}=ind{j}+1;
                            end
                        else
                            index{combNum+1,j}=index{combNum,j};
                        end
                    end
            
                    qzMean=A{j,index{combNum+1,j}}*mean+b{j,index{combNum+1,j}};
                    qzCovar=A{j,index{combNum+1,j}}*covar*A{j,index{combNum+1,j}}'+S{j,index{combNum+1,j}};
            
                    [T,err]=cholcov(qzCovar,0);
            
                    if err~=0
                        q_z=mvnpdf(z{j},qzMean,vpaMat(qzCovar,5));
                    else
                        q_z=mvnpdf(z{j},qzMean,qzCovar);
                    end
                    
                    if (isempty(lambda)==0) && (isempty(x_min)==0) && (isempty(x_max)==0) && (isempty(y_min)==0) && (isempty(y_max)==0)
                        denomWeight=denomWeight*(q_z/...
                            (lambda*unifpdf([1 0]*z{j},x_min,x_max)*unifpdf([0 1]*z{j},y_min,y_max)));
                    else
                        denomWeight=denomWeight*q_z;
                    end
                else
                    continue
                end
            end
            combNum=combNum+1;
            sumDenom=sumDenom+denomWeight;
        end
        L{i}=sumDenom;
    end
end