function f = evalerror(xt,gtd)
xet = gtd(1,1:length(xt(1,:))) - xt(1,:);
yet = gtd(2,1:length(xt(1,:))) - xt(2,:);
zet = gtd(3,1:length(xt(1,:))) - xt(3,:);

sxe = xet.^2;
sye = yet.^2;
sze = zet.^2;

%rmse
msxe = sqrt(sum(sxe)/(length(sxe)-1));
msye = sqrt(sum(sye)/(length(sye)-1));
msze = sqrt(sum(sze)/(length(sze)-1));

%std
stdxe = std(sxe);
stdye = std(sye);
stdze = std(sze);

%mean
mxe = mean(sxe);
mye = mean(sye);
mze = mean(sze);

dig = -2;
disp([num2str(roundn(mxe,dig)),' & ',num2str(roundn(mye,dig)),' & ',num2str(roundn(mze,dig)),' & ', ...
    num2str(roundn(msxe,dig)),' & ',num2str(roundn(msye,dig)),' & ',num2str(roundn(msze,dig)),' & ', ...
    num2str(roundn(stdxe,dig)),' & ',num2str(roundn(stdye,dig)),' & ',num2str(roundn(stdze,dig)),' \\'])

f(:,1)=[mxe;mye;mze];
f(:,2)=[msxe;msye;msze];
f(:,3)=[stdxe;stdye;stdze];


