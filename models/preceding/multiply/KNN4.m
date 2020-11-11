function PPT41 =KNN4(Name4,testD4)
load F-scorezhiL2_4.mat F1
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
    ppp2(i,:)=Str;
end
for i=1:Np4
    Str=positive4{1,i};
    Str=char(Str);
    Str=upper(Str);%���������е�Сд����һ�ɻ��ɴ�д
    positive4{1,i}=Str;
    ppp4(i,:)=Str;
end
for i=1:Np5
    Str=positive5{1,i};
    Str=char(Str);
    Str=upper(Str);%���������е�Сд����һ�ɻ��ɴ�д
    positive5{1,i}=Str;
    ppp5(i,:)=Str;
end

ppp=ppp4;
nnn=[ppp2;ppp5];
Np=length(ppp);
Nn=length(nnn);

x1=Name4;
WNp=length(x1);%number of positive samples

for i=1:WNp
    Str=testD4{1,i};
    Str=char(Str);
    Str=upper(Str);%�����������е�Сд����һ�ɻ��ɴ�д
    testD4{1,i}=Str;
    testD44(i,:)=Str;
end
M1=length(testD4{1,1});
xp=[ppp;nnn];
M2=length(xp(:,1));
ss1=[1,M2];
o=0;
for k=10:10:200
    o=o+1;
    for j=1:WNp
        for i=1:M2
            a=0;
            for ii=1:M1
                if strcmp(testD44(j,ii),xp(i,ii))
                    a=a+2;
                else
                    a=a-1;
                end
            end
            ss1(1,i)=a;
        end
        s1=-ss1;
        [q1,order1]=sort(s1);
        h1=0;
        for i=1:k+1
            if order1(i)<=Np
                h1=h1+1;
            end
        end
        w1(j,o)=h1/(k+1);
    end 
end
for i=1:5
    k=F1(2,i);
    PPT41(:,i)=w1(:,k);%����������������������F-score������������
end
