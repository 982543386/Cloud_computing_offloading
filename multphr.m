%function [x,mu,lam,ouput]=multphr(fun,hf,gf,dfun,dhf,dgf,x0) 
%fun dfun�ֱ���Ŀ�꺯�������ݶ�
%hf dhf�ֱ��ǵ�ʽԼ����������Jacobi�����ת��
%gf dgf�ֱ��ǲ���ʽԼ������Jacobi�����ת��
%x0�ǳ�ʼ��
%x�ǽ������Ž�
%mu lam�ֱ�����Ӧ�ڵ�ʽԼ���Ͳ���ʽԼ���ĳ���������lamda*��
%output�ǽṹ������������Ƽ�Сֵf�������������ڵ���������

% function multphr(m)

global alpha P f SNR beta  gama0  W_sum D_sum rho ant;
    m=8;    %�ӽڵ��� Ŀǰ����������Ӧ����3,����������ӦС��10������Ŀǰ������������
    alpha=0.5;
    a1=50;     %mW
    b1=100;    %mW
    a3=4;  %8000kB/s  % 8000khz  %8Mhz
    b3=16;  %Mhz
    a4=20;
    b4=35;
    gama0=20;
    W_sum=80;       %�����ز��� %�ȿ��ǵ�ʽ��ѧ�����Ŀ�ʼҲһֱ��Ϊ��=   %�������գ���ȥ��֮ǰ���ģ�û�ҵ���  ������(������)      80    %�ܴ����
    D_sum=40;      
    %%%%%%%%% m=2Ӧ��Ҫ����һ�£�8*m
    %%%%%%%%%%%%%%%%%%%%��һ���������emmm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Q0=zeros(1,m);  %��ʼ��
    beta=1-alpha ;
    rho=2^(-1/2);
    P = a1 + (b1-a1).*rand([1 m]);  %�����䣨a��b���ڲ������ȷֲ��������   %m�� n��
% %    g = a2 + (b2-a2).*rand([1 m]);
    f = a3 + (b3-a3).*rand([1 m]);
    SNR = a4 + (b4-a4).*rand([1 m]);

maxk=80;       %���������� %����� %�����̫�෴���ᵼ��Ŀ�꺯��ֵ���20�Ͳ���  % 80
%Mk=2.0;          %������     %ԭ�Ƚ�sigma
Mk=2.0;     
%epsilon=1e-5;    %��ֹ���ֵ
epsilon=0.0001;
epsilon2=0.1;
epsilon3=1;
eta=10;          %�Ŵ�����ֵ��һ��ȡ10
theta=0.8;       %PHR�㷨�е�ʵ����
k=0;             %���������
%ink=0;           %�ڵ�������

 ant=200;   % ��������
 %he=zeros(2,ant);
 he=zeros(1,2);
 %gi=zeros(1,ant);
% X0{1,:}=zeros(1,m); 
% X0{2,:}=zeros(1,m);
 X0=cell(2,ant);
%%%%%%%%%%%%%%%%%%%������ʼ1000����%%%%%%%%��ʵֻ�趨һ��Ҳ�У���Ϊ�������ֵҲ������ֵ����x��������1000ֻ���ϵģ���һ���Ļ����о�Ӧ��������һ��ACO�õ�����ֵ��������û��Ҫ��he��ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���У�����������Ҫ��1000������Ϊ��ʼֵ�Լ������ģ��������������ǰ�1000����Ϊһ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i=1:ant 
   X0{1,i}=(0+(W_sum-0)*rand(1,m)); %�������ÿֻ���ϵĳ�ֵλ��  %�� W  %�͸���{}�����ǣ����������ó�����cell�������Ǹ����cell��ֵ
   X0{2,i}=(0+(D_sum-0)*rand(1,m)); %��  D
  % ta(i)= Q(X0{1,i},X0{2,i},Mk,lamdak);     %��Qû��ϵ��Ҫ�ľ���index��he
 end  
   %  [ta_best,best_index]=max(ta);
   %  he_X={X0{1,best_index};X0{2,best_index}};             %W   D   
%    % % he_X={X{1,i};X{2,i}};
%    % % he(:,ant)=feval(hf,he_X);   %��ʽԼ��  %����һ�� X{��,i}ȡ������һ�У�����   %ʵ���˿��Ժ��������Ը�һ�и�ֵ  he��һ�У�W�Ĳ�ֵ  he�ڶ��У�D�Ĳ�ֵ
   %  he=feval(hf,he_X); 
%     % %gi(i)=feval(gf,X{2,i});    %����ʽԼ�� 
% he_X=cell(2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������˺þøо�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%n=length(x);
% l=length(he);       %������2
% m=length(gi);    
% mu=0.1*ones(l,1); 
% lam=0.1*ones(m,1);
%lamdak=0.1*ones(2,ant); 
 lamdak=0.1*ones(1,2);
% lam=0.1*ones(ant,1);
betak=10;     
betaold=10;     %����������ֹ����������ֵ
h=zeros(1,maxk);
min_help=zeros(1,maxk);
Qobj_min=zeros(1,maxk);
maxxyt=cell(2,maxk); %����x��W��������y��D��
times=100;
while betak>epsilon && k<maxk 
   %����BFGS���������Լ��������  [ik,x,val]=bfgs('mpsi','dmpsi',x0,fun,hf,gfun,dfun,dhf,dgf,mu,lam,Mk);   
    % ink=ink+ik;  
    [lastW_distri,lastD_distri,maxx,maxy,minvalue]=antcolony_offload(m,X0,Mk,lamdak,k,times) ;    %�ĳɷ���ֵ����һ�ηֲ���1000����Ҳ���ò��ף���Ϊ�еĵ��ھֲ����ţ���Ҫ�Ļ���maxx��maxy  
     
%      %he_X={maxx;maxy};
%      %he=feval(hf,he_X);       %y
       he=hf(maxx,maxy);
     %he=hf(lastW_distri,lastD_distri);
     %he=cell2mat(he);
%     % gi=feval(gf,x);
     betak=sqrt(norm(he,2)^2);            %+norm(min(gi,lam/Mk),2)^2);  %norm(he,2)���ؾ���ġ�2������  %betak�൱��h��x^k��,betaold�൱��h��x^(k-1��)
    
     h(k+1)=betak;   %�±겻�ܴ�0��ʼ %h(1)��Ӧk=0
     min_help(k+1)=minvalue;   %��������
     Qobj_min(k+1)=Q_need(maxx,maxy); %����Ŀ�꺯��
     maxxyt{1,k+1}=maxx;
     maxxyt{2,k+1}=maxy;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
     if betak>epsilon              %û�ﵽhf����0�����³�������
         lamdak=lamdak-Mk*he;      %mu�ĳ�lamdak��  %��Ҫ����
     %    lam=max(0.0,lam-Mk*gi);   %����ʽ��
            if k>=2 && betak>theta*betaold     %�ж���������
                Mk=eta*Mk;
            end
     end 
     if betak<epsilon3    %�ڿ��������ʵ������һЩ������ֵ
         times=200;    
     end
%    h(k)=betak;
     k=k+1;    %�����ĵ��������Ƕ�Mk��lamdak���Ե�
     %k=0����Mk�ȵ�����0�Σ����Ƕ�h min obj_min���Ѿ������˵�һ��
     %Ҳ����˵%%%%%�Ƿֽ���
     %���һ�ε�����Mk��Lmadak��û���õ�
     betaold=betak;
     X0=[lastW_distri;lastD_distri];  %�������Ǵ����ţ������Ѿ���cell��  %���л���Ҫ1000���㣬��Ȼû�����������ǿ��������1000����ר��Ϊ�����ã�maxx��maxyΪhe����
                                  %��Ȼ����������...
     
end
 k_plot=(1:1:k);
figure,plot(k_plot-1,h(k_plot)),title('h(k)ÿ�ε����仯����');grid on;
figure,plot(k_plot-1,Qobj_min(k_plot)),title('����Ŀ�꺯��ÿ�ε�����Сֵ�仯����');grid on;hold on;
Q_AA=AA_offload(m);
Q_RA=RA_offload(m);
plot([0,k],[Q_AA,Q_AA],'--r');
figure,plot(k_plot-1,min_help(k_plot)),title('��������ÿ���������Сֵ�仯����');grid on;
%  k_plot2=(1:1:k-10);
% figure,plot(k_plot2-1,min_help(k_plot2)),title('��������ÿ���������Сֵ�仯����');grid on;

j_index=0;
j=zeros(1,k);
for jj=1:1:k
  if h(jj)<epsilon2
      j(j_index+1)=jj;
      j_index=j_index+1;
  end
end
temp=Qobj_min(j(1:j_index));
[Qobj_minvalue,Q_obj_index]=min(temp);  %b  = [a(1:10),a(20:25),a(51:60)];
  W_need=maxxyt{1,j(Q_obj_index)};
  D_need=maxxyt{2,j(Q_obj_index)};
% % f=feval(fun,x);
% % output.fval=f;
% output.iter=k;    %���������
% % %output.inner_iter=ink;
% output.beta=betak;
% output.Q_minvalue=minvalue;
% %output.Qobj_minvalue=Q_need(maxx,maxy);
output.ACO_ALMM=Qobj_minvalue;
output.AA=Q_AA;
output.RA=Q_RA;

