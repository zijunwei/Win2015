#!/usr/bin/env python

import sys, os, subprocess



# format: "http://sachnoionline.com/data/file/LE LUU THOI XA VANG-01.mp3"

#prefix = "http://sachnoionline.com/data/file/LE LUU THOI XA VANG-"
#prefix = "http://sachnoionline.com/data/file/GIA BIET BONG TOI "

#prefix = "http://sachnoionline.com/data/file/TREN BUC GIANG-"
#prefix = "http://sachnoionline.com/data/file/TRONG GIA DINH-"
#prefix = "http://cdnport.com/radio/truyen-kinh-dien/than-thoai-hy-lap/than-thoai-hy-lap-p"
#prefix = "http://cdnport.com/radio/truyen-kinh-dien/manh-dat-lam-nguoi-nhieu-ma/manh-dat-lam-nguoi-nhieu-ma-p"
#prefix = "http://cdnport.com/radio/truyen-kinh-dien/hon-ma-dem-giang-sinh/hon-ma-dem-giang-sinh-p"
#prefix = "http://data.thuviensachnoi.vn//ThuVienSachNoi/VanHoc/VanHocNuocNgoai/HoiUcCuaMotGeisha/Phan"
prefix = "http://sachnoionline.com/data/file/bivo"
#prefix = "http://data.thuviensachnoi.vn//ThuVienSachNoi/VanHoc/VanHocNuocNgoai/AQChinhTruyen/AQChinhTruyen"
startIdx = 1
endIdx   = 26
idxs = range(startIdx, endIdx+1)
#idxs = [34, 6, 29, 4, 30, 36, 5, 31, 1, 18, 9];

processes = set()
max_processes = 50

if __name__ == '__main__':
   for i in idxs:
      audioFile = "%s%02d.mp3" % (prefix, i)
      #audioFile = "%s%d.mp3" % (prefix, i)
      # cmd = 'wget --tries=5 "%s"' % audioFile
      # print cmd
      # subprocess.call(["wget", audioFile])
      #os.system(cmd)

      processes.add(subprocess.Popen(['wget', audioFile]))
      if len(processes) >= max_processes:
         os.wait()
         processes.difference_update(p for p in processes if p.poll() is not None)      
