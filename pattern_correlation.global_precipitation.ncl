load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin             

 path="/data2021/cmip6/GMMIP/"
 
 filename_list=path+"/process/data/pr/clim/filename_tip-nosh.txt"
 N_run = numAsciiRow(filename_list)
 filename_1=asciiread(filename_list,(/N_run/),"string")
 print(filename_1)

 filename_list=path+"/process/data/pr/clim/filename_hist.txt"
 N_run2 = numAsciiRow(filename_list)
 filename_2_temp=asciiread(filename_list,(/N_run2/),"string")
 filename_2=filename_2_temp(1:3)
 print(filename_2)

 filename_list=path+"/process/data/pr/clim/filename_tip.txt"
 filename_3=asciiread(filename_list,(/N_run/),"string")
 print(filename_3)

 var=new((/N_run,2,12/),float,-999.0)
 do i_run=0,N_run-1

  filename=path+"/process/data/pr/clim/"+filename_1(i_run)
  data=addfile(filename,"r")
  var_nosh=(data->tas)*24*60*60
  dim=dimsizes(var_nosh)
  print(dim)

  var_all=new((/12,dim(1),dim(2)/),float,-999.0)
  var_t=new((/12,dim(1),dim(2)/),float,-999.0)
  var_m=new((/12,dim(1),dim(2)/),float,-999.0)

  filename=path+"/process/data/pr/clim/"+filename_1(i_run)
  data=addfile(filename,"r")
  var_nosh=(data->tas)*24*60*60

  filename=path+"/process/data/pr/clim/"+filename_2(i_run)
  data=addfile(filename,"r")
  var_hist=(data->tas)*24*60*60

  filename=path+"/process/data/pr/clim/"+filename_3(i_run)
  data=addfile(filename,"r")
  var_tip=(data->tas)*24*60*60

  var_all=var_hist-var_tip
  var_t=var_hist-var_nosh
  var_m=var_nosh-var_tip
  delete(var_hist)
  delete(var_tip)
  delete(var_nosh)
 
  var(i_run,0,:)=pattern_cor(var_all,var_m,1.0,0)
  var(i_run,1,:)=pattern_cor(var_all,var_t,1.0,0)
  delete(var_all)
  delete(var_m)
  delete(var_t)

 end do

 corr=dim_avg_n(var,0)
 prob=dim_stddev_n(var,0)

 wks=gsn_open_wks("eps",path+"/process/plot/pr/tip/ensemble/pr_scorr.tm_f.mon.1979_2014.ensemble_cesm213.v2")
 gsn_define_colormap(wks,"ncl_default")
 res=True
 res@gsnDraw=False           ; don't draw
 res@gsnFrame=False          ; don't advance frame
 res@gsnXYBarChart=True
 res@gsnXYBarChartBarWidth=0.399
 res@gsnXYBarChartOutlineThicknessF=0.111
 res@gsnXYBarChartColors=(/2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242/)
 res@gsnYRefLine=0
 res@gsnAboveYRefLineBarColors=(/2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242,2,242/)
 res@gsnBelowYRefLineBarColors=(/33/)

 res@gsnStringFont=21
 res@gsnStringFontHeightF=0.02
 res@gsnLeftStringOrthogonalPosF=0.23
 res@gsnLeftStringParallelPosF=0.02
 res@gsnLeftString=""
 res@gsnRightString=""
 res@gsnCenterString=""
 res@tiXAxisFont=21
 res@tiYAxisFont=21
 res@tiYAxisFontHeightF=0.018
 res@tiXAxisFontHeightF=0.018
 res@tiMainString="" ;add titles
 res@tiXAxisString=""
 res@tiYAxisString=""
 res@tmXBLabelFont=21 ;x axis bottom font
 res@tmXBLabelFontHeightF=0.018
 res@tmYLLabelFont=21 ;y axis left font
 res@tmYLLabelFontHeightF=0.018
 res@tmXBMinorOn=True
 res@tmYLMinorOn=True
 res@tmYLPrecision=2
 res@tmYROn=False
 res@tmXTOn=False
 res@tmYLMinorOn=True
 res@tmXBMajorOutwardLengthF = 0.015 ; Don't draw tickmarks b/c they 
 res@tmXBMajorLengthF = 0.015 ; were drawn on previous plot. 
 res@tmXBMinorOutwardLengthF = 0.006 ; Don't draw tickmarks b/c they 
 res@tmXBMinorLengthF = 0.006 ; were drawn on previous plot. 
 res@tmXBMinorThicknessF=1
 res@tmYLMinorOutwardLengthF = 0.006 ; Don't draw tickmarks b/c they 
 res@tmYLMinorLengthF = 0.006 ; were drawn on previous plot. 
 res@tmYLMinorThicknessF=1
 res@tmYLMajorOutwardLengthF = 0.015 ; Don't draw tickmarks b/c they 
 res@tmYLMajorLengthF = 0.015 ; were drawn on previous plot. 
 res@tmXBMajorThicknessF=1
 res@tmYLMajorThicknessF=1
 res@tmYRMajorThicknessF=1
 res@tmYRBorderOn      = True
 res@tmXTBorderOn      = True
 res@tmBorderThicknessF=1
 res@tmYLMode="Explicit"
 res@tmYLValues=(/-0.2,0,0.2,0.4,0.6,0.8,1/)
 res@tmYLLabels=(/"-0.2","0","0.2","0.4","0.6","0.8","1"/)
 res@tmYLMinorValues=(/-0.15,-0.1,-0.05,0.05,0.1,0.15,0.25,0.3,0.35,0.45,0.5,0.55,0.65,0.7,0.75,0.85,0.9,0.95/) 
 res@tmXBMode="Explicit"
 res@tmXBValues=ispan(1,12,1)-0.5     ; choose first 13 timesteps
 res@tmXBLabels = (/"J","F","M","A","M","J","J","A","S","O","N","D"/)
 res@tmXBLabelAngleF=0
 res@vpXF=0.2		; set left hand side start point of plot
				; as vpWidthF = .8, plot will occupy .1->.9 in NDC coords.
 res@vpYF=0.9		; set top start point of plot
				; as vpHeightF = .3, plot will occupy .5->.8 in NDC coords.

 res@txFontHeightF=0.018
 res@txFontAngleF=0.018
 res@txJust="CenterLeft"

 res@vpWidthF=0.8	; set width of plot 
 res@vpHeightF=0.4		; set height of plot
 res@vpXF=0.15		; set left hand side start point of plot
				; as vpWidthF = .8, plot will occupy .1->.9 in NDC coords.
 res@vpYF=0.9		; set top start point of plot
				; as vpHeightF = .3, plot will occupy .5->.8 in NDC coords.
 res@trYMinF=-0.21		; set minimum Y-axis value
 res@trYMaxF=1	; set maximum Y-axis value
 res@trXMinF=-0.1	; set minimum X-axis value
 res@trXMaxF=12.1		; set maximum X-axis value
 
 x=(/0.3,0.7,1.3,1.7,2.3,2.7,3.3,3.7,4.3,4.7,5.3,5.7,6.3,6.7,7.3,7.7,8.3,8.7,9.3,9.7,10.3,10.7,11.3,11.7/)
 corr_bar=new(24,"float",-999.0)
 prob_bar=new(24,"float",-999.0)
 do i_mon=0,11
  corr_bar(i_mon*2)=corr(0,i_mon)
  corr_bar(i_mon*2+1)=corr(1,i_mon)
  prob_bar(i_mon*2)=prob(0,i_mon)
  prob_bar(i_mon*2+1)=prob(1,i_mon)
 end do
 plot=gsn_csm_xy(wks,x,corr_bar,res)

 polyres=True
 polyres@gsMarkerIndex=16         ; don't advance frame
 polyres@gsMarkerSizeF=0.005         ; don't advance frame
 dum=new(1000,graphic)
 i_dum=0
  
 polyres@gsMarkerColor="grey50"         ; don't advance frame
 do i_run=0,0
  do i_mon=0,11
    xx=(/x(i_mon*2)/)
    yy=(/var(i_run,0,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
    xx=(/x(i_mon*2+1)/)
    yy=(/var(i_run,1,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
  end do
 end do

 polyres@gsMarkerColor="grey30"         ; don't advance frame
 do i_run=1,1
  do i_mon=0,11
    xx=(/x(i_mon*2)/)
    yy=(/var(i_run,0,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
    xx=(/x(i_mon*2+1)/)
    yy=(/var(i_run,1,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
  end do
 end do

 polyres@gsMarkerColor="grey10"         ; don't advance frame
 do i_run=2,2
  do i_mon=0,11
    xx=(/x(i_mon*2)/)
    yy=(/var(i_run,0,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
    xx=(/x(i_mon*2+1)/)
    yy=(/var(i_run,1,i_mon)/)
    dum(i_dum)=gsn_add_polymarker(wks,plot,xx,yy,polyres)
    i_dum=i_dum+1
  end do
 end do

 draw(plot)
 frame(wks)

end
