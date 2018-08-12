function RSIndex = GetResampleIndex(Weight, NumParticles)

% Usage
%   RSIndex = GetResampleIndex(Weight, NumParticles);
RSIndex = zeros(NumParticles, 1);

NormalisationFactor = sum(Weight);
Weight = Weight/NormalisationFactor;

CSW = cumsum(Weight);
% ResampledWeight = 1/NumParticles;

% Iindex = 1;
u1 = rand(1,1)/NumParticles;

% uj = u1 + (0:NumParticles-1)/NumParticles; % 2

for Jindex = 1:NumParticles
%     uj = u1 + (Jindex-1)/NumParticles; % 1
%     Iindex = find(uj<CSW(Iindex:end), 1, 'first'); % 1
    RSIndex(Jindex) = find(u1+(Jindex-1)/NumParticles<CSW, 1, 'first'); % 2
end
