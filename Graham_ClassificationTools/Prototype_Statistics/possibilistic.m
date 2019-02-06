%DESCRIPTION: DOES EXACT SAME THING AS Learn_Prototypes, but without clustering
% In other words, just retrieves mean and std possibilistic parameters a and b

%INPUT: 
%---------------------------------------------------------------
% CentM: Positive centers
% CentF: Negative centers
% Mines: Positive Instances
% FA: Negative Instances
%OUTPUT:
%---------------------------------------------------------------
% memb_params: (struct) membership params

function [memb_params] = possibilistic(CentM, CentF, Mines ,FA) 
 
%%%%% Label Prototypes  
Signatures   = [Mines; FA];
NoSigMines   = size(Mines,1);
NoSigFA      = size(FA,1);
    
Centers     = [CentM; CentF];

%*********************************************************************
d = zeros(size(Centers,1), size(Signatures,1));
for i = 1:size(Centers,1)
    for j = 1:size(Signatures,1)
        d(i,j) = norm(Centers(i,:) - Signatures(j,:));
    end;
end;
fixed_params.KNNmemb = 5; 
m_num = size(Mines,1);

[s_d s_ind] = sort(d); 
d_all = [];

d_m = [];
d_fa = []; 
for i = 1:size(Signatures,1)
    d_all = [d_all s_d(1:fixed_params.KNNmemb,i)];    
    if i <= m_num
        d_m = [d_m s_d(1:fixed_params.KNNmemb,i)];    
    else
        d_fa = [d_fa s_d(1:fixed_params.KNNmemb, i)];    
    end;        
end;

t = d_all(:);
ind = find(t == 0);
t(ind) = [];
t1 = sort(t);
t2 = t1(1:floor(0.75*end));
memb_params.all_a = mean(t2);
memb_params.all_b = std(t2);

t = d_m(:);
ind = find(t == 0);
t(ind) = [];
t1 = sort(t);
t2 = t1(1:floor(0.75*end));
memb_params.m_a = mean(t2);
memb_params.m_b = std(t2);

t = d_fa(:);
ind = find(t == 0);
t(ind) = [];
t1 = sort(t);
t2 = t1(1:floor(0.75*end));
memb_params.fa_a = mean(t2);
memb_params.fa_b = std(t2);
%*********************************************************************
