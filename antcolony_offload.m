% ��Ⱥ�㷨�������ֵ�ĳ���
%function max_need=antcolony_offload(m,)  
function [lastW_distri,lastD_distri,maxx,maxy,minvalue]=antcolony_offload(m,X,Mk,lamdak,k,times)
%global W_sum;
%global alpha P f SNR beta  gama0  W_sum D_sum rho;
global ant;
%ant=200;   % ��������
%times=50; % �����ƶ�����
rou=0.8; % ��Ϣ�ػӷ�ϵ��
p0=0.2; % ת�Ƹ��ʳ���
lower_1=zeros(1,m); % ����������Χ  &��   %W����
upper_1=20.*ones(1,m); %   ��
lower_2=zeros(1,m); %  ��     %D
upper_2=30.*ones(1,m); %   ��
%subcarrier=zeros(1,m);
% X{1,:}=zeros(1,m);   %�д� ��û��  %��ʵX{1,:}������X{1,1},�Ǹ�����
% X{2,:}=zeros(1,m);
% X=cell(2,ant);
% %�������ɾ�����ô����Ԫ��Ϊcell����ȡ�����cell��������X{}����������cell����ô��ȡcell�ã�������ȡcell����Ϊ������{}
p1=zeros(times,ant);
tau_best=zeros(1,times);
minvaluet=zeros(1,times);
tau=zeros(1,ant);
%N=512;    %���ز�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������%%%%%%%%%%%
  %a1 b1 a3 b3 a4 b4 gama0 W_sum D_sum Q beta P f SNR; 
%     m=4;    %�ӵ������㿪ʼͻ�䡣����
%     alpha=0.5;
%     a1=50;     %mW
%     b1=100;    %mW
%     a3=8;  %8000kB/s  % 8000khz  %8Mhz
%     b3=10;  %Mhz
%     a4=20;
%     b4=35;
%     gama0=20;
%     W_sum=20;       %�����ز��� %�ȿ��ǵ�ʽ��ѧ�����Ŀ�ʼҲһֱ��Ϊ��=   %�������գ���ȥ��֮ǰ���ģ�û�ҵ���  ������(������)           %�ܴ����
%     D_sum=30;        
% % Q0=zeros(1,m);  %��ʼ��
%     beta=1-alpha ;
%     rho=2^(-1/2);
%     P = a1 + (b1-a1).*rand([1 m]);  %�����䣨a��b���ڲ������ȷֲ��������   %m�� n��
% % %    g = a2 + (b2-a2).*rand([1 m]);
%     f = a3 + (b3-a3).*rand([1 m]);
%     SNR = a4 + (b4-a4).*rand([1 m]);
%    Mk=100;
%    lamdak=5;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:ant 
%   X{1,i}=(lower_1+(upper_1(1,1)-lower_1(1,1)).*rand(1,m)); %�������ÿֻ���ϵĳ�ֵλ��  %�� W
%   X{2,i}=(lower_2+(upper_2(1,1)-lower_2(1,1)).*rand(1,m)); %��  D
%   
%   tau(i)= Q(X{1,i},X{2,i},Mk,lamdak); %��iֻ���ϵ���Ϣ��   
%                            %%����λ�ú���ֵԽ����Ϣ��Խ��
% end
for i=1:ant
    tau(i)=Q(X{1,i},X{2,i},Mk,lamdak);  %lamdak(:,i)������
end

for t=1:times  % ��t���ƶ�
    lamda=1/t; %����ϵ�������ƶ��������������  %%�����ֵ�ƽ����ֵ�Խ��Խϸ����ΪԽ��Խ�ӽ�����ֵ  %%%���Կ��Ǹı�˹�ϵ������
    [tau_best(t),bestindex]=max(tau); %��t���ƶ�������ֵ����λ��  %������������λ��F���  %��һ���ƶ���t=1ʱ��Ҳ���ǳ�ʼλ��
    %taubestt(t)=tau(bestindex);  %��taubestһ����������Ҳû��
    minvaluet(t)=-Q(X{1,bestindex},X{2,bestindex},Mk,lamdak);
    %%%%%%%%%%%Ϊʲô�����෴����������������������������������������������������������������
    %%%%%%%%���bestindex�Ƕ�i���Ե�û���͸û����ͼ������tau_best�ģ�tau������i���������ⲻ����
    %%%%%%%%%ɵ���ˣ�tau����Ϣ�أ�����֮ǰ��ӡ�ǣ�-minvaluet��ȫ���ǵ�ǰ��Ŀ�꺯��ֵ����Ȼ��һ����ֻ�е�һ�����෴��
    
    for i=1:ant    %��iֻ����
      p1(t,i)=(tau(bestindex)-tau(i))/tau(bestindex); %����ֵ���iֻ���ϵ�ֵ�Ĳ��
                                         %����״̬ת�Ƹ���   %%���Խ��ת�Ƹ���Խ��
    end 
    
    for i=1:ant 
       if p1(t,i)<p0   %�ֲ�����  С��ת�Ƹ��ʳ���  %�����ֵ��Զ������ôҪת�ƣ�����lamda=1��Ҳֻ���˲���1�Ĳ���
                                 
         temp1=X{1,i}+(2.*rand(1,m)-1)*lamda; %�ƶ�����  %�ƶ�����Խ�࣬����ԽС���ƽ�����  %randӦ���Ǵ���0-1������2*rand-1�����˶�ά���ƶ��������
                                        %nάӦ��Ҳһ����ÿһά���������������� %��n��temp��ҪŪ������
         temp2=X{2,i}+(2.*rand(1,m)-1)*lamda; 
       else 
      %ȫ������
         temp1=X{1,i}+(upper_1(1,1)-lower_1(1,1)).*(rand(1,m)-0.5);   %%���ǻᳬ����Χ�ɣ�����X���ϰ벿�֣�rand=1�����ܵ��Ͻ������   ������Խ�紦�� ��������߽�
                                                      %�е��������������λ�ã�����ʵ����ԭ�����������������޹�����..
         temp2=X{2,i}+(upper_2(1,1)-lower_2(1,1)).*(rand(1,m)-0.5); 
       end  
%%%%%%%%%%%%%%%%%%%%%% Խ�紦��%%%%%%%%%%%%%%%%%%%%%
       for j=1:1:m
         if temp1(j)<lower_1(j);    %��ʵlower��Ԫ�ض�һ����Ŀǰ����0
            temp1(j)=lower_1(j); 
         end 
         if temp1(j)>upper_1(j) 
            temp1(j)=upper_1(j); 
         end 
         if temp2(j)<lower_2(j) 
            temp2(j)=lower_2(j); 
         end 
         if temp2(j)>upper_2(j) 
            temp2(j)=upper_2(j); 
         end 
       end
%%%%%%%%%%%%%%%%%%%%%%% 
       if Q(temp1,temp2,Mk,lamdak)>Q(X{1,i},X{2,i},Mk,lamdak) % �ж������Ƿ��ƶ� %������Щ�߳ɹ��ģ��ڴ˻�����������ߡ�û�ɹ�������һ�λ������ٴ�������ߣ�
         X{1,i}=temp1;         %%���ڸ���������λ��
         X{2,i}=temp2; 
       end 
    end 
    
    for i=1:ant
       tau(i)=(1-rou).*tau(i)+Q(X{1,i},X{2,i},Mk,lamdak);  %������Ϣ��   %��ΪһЩ���ϵ�����ˣ�F���� 
                                               %���ܸ�û���£��������϶��Ǽ�ǿ����Ϣ�أ�������ȷ���������Q���󣬼�ǿ������
       
    end  
    
end 

 lastW_distri=X(1,:);   %ant��W������ÿ���Ǹ�cell�� %��������cell Ҳ����˵�ã�����������Ҫ��Ӧ������������Ӧ����{}�ɣ�����{1����}ȡ�����ǵ�һ��
 lastD_distri=X(2,:);   %����mulphr��X0������{lastW_distri;lastD_distri},��Ϊ�˼��Ѿ���cell��= =
 t=(1:1:times);
%  figure,plot(t,tau_best(t)),title('��Ϣ��ÿ�ε�����ֵ(����������)�仯����');hold on;
%  text(150,tau_best(150),num2str(k));
 plot(t,minvaluet(t)),title('���������ڵ�����ֵ(����������)�仯����');hold on;  %Ӧ�ú������Ǹ����෴���Ŷ�
%text(10+2*k,minvaluet(10+2*k),num2str(k));
%text(k+1,minvaluet(k+1),num2str(k));
[~,max_index]=max(tau);       %����֣��ҵ���Ϣ����ǿ�Ķ�Ӧ��λ�á�����Ϊʲô��ֱ���Ҵ�ʱeval(f)�����ģ�  %��һ����
maxx=X{1,max_index};              %W
maxy=X{2,max_index};              %D
maxvalue=Q(X{1,max_index},X{2,max_index},Mk,lamdak);   %��max_value�������� %û�а�
minvalue=-maxvalue;   
%max_need=Q_need(maxx,maxy); 

% accu=W_sum/N; 
% for i=1:m
%   if mod(maxx(i),accu)>=accu/2
%     maxx(i)=ceil(maxx(i)/accu)*accu;
%   else
%     maxx(i)=floor(maxx(i)/accu)*accu;
%   end
% end
% subcarrier=maxx./accu;

%%end 