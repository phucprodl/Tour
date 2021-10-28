use master 
go
IF EXISTS (SELECT NAME FROM SYS.DATABASES WHERE NAME='QUANLYTOUR')
	DROP DATABASE QUANLYTOUR
go
create database QUANLYTOUR
ON(NAME='QLT_DATA',FILENAME='D:\SQL\QLT.MDF')
LOG ON(NAME='QLT_LOG',FILENAME='D:\SQL\QLT.LDF')
GO 

go
use QUANLYTOUR
go

set dateformat dmy
create table DIEMTQ 
(
	MaDTQ varchar(5) primary key NOT NUll,
	TenDTQ nvarchar(100),
	Noidung nvarchar(100),
	Ynghia nvarchar(100),
)

create table TOUR 
(
	MaTour varchar(5) primary key NOT NUll,
	TenTour nvarchar(100),
	Songay int,
	Sodem int,
)
create table CT_THAMQUAN
(
	MaTour varchar(5) NOT NULL ,
	MaDTQ varchar(5) NOT NULL ,
	Thoigian int,
	PRIMARY KEY (MaTour,MaDTQ),
)
create table HOPDONG 
(
	SoHD varchar(5) primary key NOT NUll,
	NgaylapHD date,
	SoNguoidi int,
	NoidungHD nvarchar(40),
	Noidon nvarchar(100),
	NgaydiHD date,
	MaTour varchar(5),
	MaDoan varchar(5),
)

create table DOAN 
(
	MaDoan varchar(5) primary key NOT NUll,
	HoTen nvarchar(100),
	Phai nvarchar(5),
	Ngaysinh date,
	Diachi nvarchar(100),
	Dienthoai nvarchar(15),
)

create table DIEMDUNGCHAN 
(
	MaDDC varchar(5) primary key NOT NUll,
	TenDDC nvarchar(100),
	Thanhpho nvarchar(100),
)

create table LOTRINH
(
	MaNoiDi varchar(5) NOT NULL ,
	MaNoiDen varchar(5) NOT NULL ,
	PRIMARY KEY (MaNoiDi,MaNoiDen)
)

create table LOTRINH_TOUR
(
	MaTour varchar(5) NOT NULL ,
	MaNoiDi varchar(5) NOT NULL ,
	MaNoiDen varchar(5) NOT NULL ,
	SongayO int,
	SongaydicuaPT int,
	LoaiPhuongtien nvarchar(100),
	LoaiKhachsan nvarchar(100),
	PRIMARY KEY (MaTour,MaNoiDi,MaNoiDen)
)

create table CHUYEN 
(
	MaChuyen varchar(5) primary key NOT NUll,
	Tenchuyen nvarchar(100),
	NgaydiCuaChuyen date,
	MaNVHDDL varchar(5),
	MaTour varchar(5),
)

create table HOPDONG_NV
(
	SoHD varchar(5) NOT NULL ,
	MaNVHDDL varchar(5) NOT NULL ,
	NoidungHD_NV nvarchar(100),
	PRIMARY KEY (SoHD,MaNVHDDL,NoidungHD_NV),
)

create table NHANVIENHDDL 
(
	MaNVHDDL varchar(5) primary key NOT NUll,
	TenNV nvarchar(100),
	NgaysinhNV date,
	PhaiNV nvarchar(5),
	DiachiNV nvarchar(100),
	DienthoaiNV nvarchar(15),
)
ALTER TABLE CT_THAMQUAN ADD  constraint fk_CT_THAMQUAN_TOUR foreign key (MaTour) references TOUR(MaTour);
ALTER TABLE CT_THAMQUAN ADD  constraint fk_CT_THAMQUAN_DIEMTQ foreign key (MaDTQ) references DIEMTQ(MaDTQ);
ALTER TABLE HOPDONG ADD  constraint fk_HOPDONG_TOUR foreign key (MaTour) references TOUR(MaTour);
ALTER TABLE HOPDONG ADD  constraint fk_HOPDONG_DOAN foreign key (MaDoan) references DOAN(MaDoan)
ALTER TABLE LOTRINH_TOUR ADD  constraint fk_LOTRINH_TOUR_TOUR foreign key (MaTour) references TOUR(MaTour);
ALTER TABLE LOTRINH_TOUR ADD  constraint fk_LOTRINH_TOUR_LOTRINH foreign key (MaNoiDi,MaNoiDen) references LOTRINH(MaNoiDi,MaNoiDen);
ALTER TABLE CHUYEN ADD  constraint fk_CHUYEN_NHANVIENHDDL foreign key (MaNVHDDL) references NHANVIENHDDL(MaNVHDDL);
ALTER TABLE CHUYEN ADD  constraint fk_CHUYEN_TOUR foreign key (MaTour) references TOUR(MaTour);
ALTER TABLE HOPDONG_NV ADD  constraint fk_HOPDONG_NV_HOPDONG foreign key (SoHD) references HOPDONG(SoHD);
ALTER TABLE HOPDONG_NV ADD  constraint fk_HOPDONG_NV_NHANVIENHDDL foreign key (MaNVHDDL) references NHANVIENHDDL(MaNVHDDL);

-- Cau 1 
select MaNVHDDL , TenNV, DATEDIFF(year, (NgaysinhNV), GETDATE()) as [Tuoi]  , PhaiNV, DiachiNV, DienthoaiNV
from NHANVIENHDDL
--Cau 2
select MaTour , TenTour, Songay,Sodem
from TOUR
--cau 3)	Liệt kê các tour có số ngày đi >= 3.
select MaTour , TenTour, Songay,Sodem
from TOUR
where Songay >=	 3
---4)	Liệt kê đầy đủ thông tin các điểm tham quan.
select * 
from DIEMTQ
--
--5)	Liệt kê các tour mà có ghé qua điểm du lịch Nha Trang.
select * 
from TOUR
where TenTour like N'%Nha Trang%'
-- 7)	Liệt kê mã các đoàn khách và số lượng khách trong đoàn mà đã đăng ký tại đại lý do ‘Nguyễn Văn A’ làm đại diện trong năm 2010.
select k.MaDoan , h.SoNguoidi
from 
--
--8)	Cho biết có bao nhiêu chuyến đi đến Nha Trang được mở trong năm 2010.
select count(MaChuyen) as [Số lượng chuyến đi NT trong năm 2010]
from CHUYEN
where Tenchuyen like N'%Nha Trang' and YEAR(NgaydiCuaChuyen) = 2010
--9)	Hiển thị thông tin những nhân viên nào đang đi tour (tính đến ngày 10/6/2010).
select h.NgaydiCuaChuyen, h.MaNVHDDL,k.TenNV,k.NgaysinhNV,k.PhaiNV,k.DiachiNV,k.DienthoaiNV
from CHUYEN h, NHANVIENHDDL k
where h.MaNVHDDL =k.MaNVHDDL and NgaydiCuaChuyen < '10/6/2010'

--10)	Hiển thị thông tin những những nhân viên nào đang rảnh trong ngày 10/6/2010.
select h.NgaydiCuaChuyen, h.MaNVHDDL,k.TenNV,k.NgaysinhNV,k.PhaiNV,k.DiachiNV,k.DienthoaiNV
from CHUYEN h, NHANVIENHDDL k
where h.MaNVHDDL =k.MaNVHDDL and NgaydiCuaChuyen = '10/6/2010'
--11)	Trong năm 2010, nhân viên nào đã lập hợp đồng cho khách du lịch theo đoàn nhiều nhất.
SELECT top 1 k.MaDoan, COUNT(MaDoan) AS "Soluong" 
  FROM HOPDONG k
  GROUP BY MaDoan
  order by Soluong DESC
  --12)	Cho biết tour du lịch nào sử dụng phương tiện ‘Ô tô’ nhiều nhất.
  SELECT  k.LoaiPhuongtien, COUNT(LoaiPhuongtien) AS "Soluong" 
  FROM LOTRINH_TOUR k
  GROUP BY LoaiPhuongtien
  order by Soluong DESC 
  --13)	Hiển thị thông tin các tour mà toàn bộ lộ trình sử dụng phương tiện là ‘Ô tô’.
  select MaTour, MaNoiDi,MaNoiDen,SongayO,SongaydicuaPT,LoaiPhuongtien,LoaiKhachsan
  from LOTRINH_TOUR
  where LoaiPhuongtien = 'Ô tô'
  --14)	Cho biết thông tin của tour bán chạy nhất.
  SELECT  k.MaTour, COUNT(MaTour) AS "Soluong" 
  FROM HOPDONG k
  GROUP BY MaTour
  order by Soluong DESC
