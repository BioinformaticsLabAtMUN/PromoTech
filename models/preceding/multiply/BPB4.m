function PPT42 = BPB4(Name4,testD4)
load F-scorezhiL2_4.mat F2
[hp2,positive2]=fastaread('sigma28promoter.txt');
Np2=length(hp2);
[hp4,positive4]=fastaread('sigma38promoter.txt');
Np4=length(hp4);
[hp5,positive5]=fastaread('sigma54promoter.txt');
Np5=length(hp5);

for i=1:Np2
    Str=positive2{1,i};
    Str=char(Str);
    Str=upper(Str);%���������е�Сд����һ�ɻ��ɴ�д
    positive2{1,i}=Str;
end
for i=1:Np4
    Str=positive4{1,i};
    Str=char(Str);
    Str=upper(Str);%���������е�Сд����һ�ɻ��ɴ�д
    positive4{1,i}=Str;
end
for i=1:Np5
    Str=positive5{1,i};
    Str=char(Str);
    Str=upper(Str);%���������е�Сд����һ�ɻ��ɴ�д
    positive5{1,i}=Str;
end

positive=positive4;
negative=[positive2,positive5];
Np=length(positive);
Nn=length(negative);
%��������������������������������������������������
%��������������������������������������������������
AA='ACGT';
%��¼ÿ����������ÿ��λ�ó��ֵĴ���
M=length(positive{1,1});
F11=zeros(4,M);%��¼ÿ����������ÿ��λ�ó��ֵĴ���
F12=zeros(4,M);
for m=1:Np
    for j=1:M
        t=positive{1,m}(j);
        k=strfind(AA,t);
        F11(k,j)=F11(k,j)+1;
    end
end
%
for m=1:Nn
    for j=1:M
        t=negative{1,m}(j);
        k=strfind(AA,t);
        F12(k,j)=F12(k,j)+1;
    end
end
F11= F11/Np;
F12= F12/Nn;

x1=Name4;
WNp=length(x1);%number of positive samples

for i=1:WNp
    Str=testD4{1,i};
    Str=char(Str);
    Str=upper(Str);%�����������е�Сд����һ�ɻ��ɴ�д
    testD4{1,i}=Str;
    %testD1(i,:)=Str;
end

testBPB=zeros(WNp,2*M);
for m=1:WNp
    l=M;
    for j=1:l
        t=testD4{1,m}(j);
        k=strfind(AA,t);
        testBPB(m,j)=F11(k,j);
        testBPB(m,l+j)=F12(k,j);
     end
end
for i=1:80
    k=F2(2,i);
    PPT42(:,i)=testBPB(:,k);%����������������������F-score������������
end
