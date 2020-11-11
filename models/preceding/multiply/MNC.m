function PPT4 = MNC(Name,testD)
%���������Ƶ��
load F-scorezhiL1.mat F4
hp=Name;
positive=testD;
Np=length(hp);%number of positive samples

for i=1:Np
    Str=positive{1,i};
    Str=char(Str);
    Str=upper(Str);%�����������е�Сд����һ�ɻ��ɴ�д
    positive{1,i}=Str;
end
AA='ACGT';
L=length(testD{1,1});%ÿ���Ķεĳ���
testMNC=zeros(Np,4);
for i=1:Np
    Peptide=positive{1,i};
    for j=1:L
        s=Peptide(j);
        k=strfind(AA,s);
        testMNC(i,k)= testMNC(i,k)+1;
    end
end
testMNC=testMNC/L;
for i=1:1
    k=F4(2,i);
    PPT4(:,i)=testMNC(:,k);%����������������������F-score������������
end
