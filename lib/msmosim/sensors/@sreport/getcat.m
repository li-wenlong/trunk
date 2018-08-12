function a = getcat( these )


Zs = { these.Z };

a = [];
for i=1:length(Zs)
    a = [a, Zs{i}.getcat];
end