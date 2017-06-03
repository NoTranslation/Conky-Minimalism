
settings_table = {
  {
    name='time',
    arg='%S',
    max=60,
    bg_colour=0xffffff,
    bg_alpha=0.1,
    fg_colour=0xffffff,    --defualt 0x0778ec
    fg_alpha=0.6,
    x=160, y=82,
    radius=55,
    thickness=3,
    start_angle=0,
    end_angle=360
  },
  {
    name='time',
    arg='%M.%S',
    max=60,
    bg_colour=0xffffff,
    bg_alpha=0.1,
    fg_colour=0xffffff,    --defualt 0x0778ec
    fg_alpha=0.6,
    x=160, y=82,
    radius=44,
    thickness=10,
    start_angle=0,
    end_angle=360
  },
  {
    name='time',
    arg='%I.%M',
    max=12,
    bg_colour=0xffffff,
    bg_alpha=0.1,
    fg_colour=0xffffff,    --defualt 0x0778ec
    fg_alpha=0.6,
    x=160, y=82,
    radius=34,
    thickness=3,
    start_angle=0,
    end_angle=360
  },
  {
     name='downspeedf',
     arg='enp3s0',
     max=800,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0xffffff,
     fg_alpha=0.6,
     x=104, y=238,
     radius=60,
     thickness=3,
     start_angle=0,
     end_angle=360
  },
  {
     name='upspeedf',
     arg='enp3s0',
     max=800,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0xffffff,
     fg_alpha=0.6,
     x=104, y=238,
     radius=50,
     thickness=10,
     start_angle=0,
     end_angle=360
   },
   {
     name='cpu',
     arg='cpu0',
     max=100,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0x607d8b,
     fg_alpha=0.6,
     x=155, y=420,
     radius=70,
     thickness=10,
     start_angle=140,
     end_angle=450
   },
   {
     name='cpu',
     arg='cpu1',
     max=100,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0x3f51b5,
     fg_alpha=0.6,
     x=155, y=420,
     radius=60,
     thickness=9,
     start_angle=140,
     end_angle=450
   },
   {
     name='cpu',
     arg='cpu2',
     max=100,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0x00796b,
     fg_alpha=0.6,
     x=155, y=420,
     radius=50,
     thickness=9,
     start_angle=140,
     end_angle=450
   },
   {
     name='cpu',
     arg='cpu3',
     max=100,
     bg_colour=0xffffff,
     bg_alpha=0.1,
     fg_colour=0xe53935,
     fg_alpha=0.6,
     x=155, y=420,
     radius=40,
     thickness=9,
     start_angle=140,
     end_angle=450
   },
   {
       name='fs_used_perc',
       arg='/',
       max=100,
       bg_colour=0xffffff,
       bg_alpha=0.1,
       fg_colour=0xd7d7d7,
       fg_alpha=0.6,
       x=285, y=590,
       radius=55,
       thickness=18,
       start_angle=0,
       end_angle=270
   },
   {
       name='memperc',
       arg='/',
       max=100,
       bg_colour=0xffffff,
       bg_alpha=0.1,
       fg_colour=0xd7d7d7,
       fg_alpha=0.6,
       x=285, y=590,
       radius=70,
       thickness=7,
       start_angle=0,
       end_angle=270
   }
}
--set line colour


--Use these settings to define the origin and extent of your clock.
  clock_r=50

--Coordinates of the centre of the clock, in pixels, from the top left of the Conky window.
  clock_x=160
  clock_y=82

--Colour & alpha of the clock hands
  clock_colour=0xe53935
  clock_alpha=0.6

--Show the seconds hand ?
  show_seconds=true

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
  return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
  local w,h=conky_window.width,conky_window.height

  local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
  local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

  local angle_0=sa*(2*math.pi/360)-math.pi/2
  local angle_f=ea*(2*math.pi/360)-math.pi/2
  local t_arc=t*(angle_f-angle_0)

  --Draw background ring
  cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
  cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
  cairo_set_line_width(cr,ring_w)
  cairo_stroke(cr)

  --Draw indicator ring
  cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
  cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
  cairo_stroke(cr)
end

function draw_clock_hands(cr,xc,yc)
  local secs,mins,hours,secs_arc,mins_arc,hours_arc
  local xh,yh,xm,ym,xs,ys

  secs=os.date("%S")
  mins=os.date("%M")
  hours=os.date("%I")

  secs_arc=(2*math.pi/60)*secs
  mins_arc=(2*math.pi/60)*mins+secs_arc/60
  hours_arc=(2*math.pi/12)*hours+mins_arc/12

  --Draw hour hand
  xh=xc+0.65*clock_r*math.sin(hours_arc)
  yh=yc-0.65*clock_r*math.cos(hours_arc)
  cairo_move_to(cr,xc,yc)
  cairo_line_to(cr,xh,yh)
  --
  cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
  cairo_set_line_width(cr,5)
  cairo_set_source_rgba(cr,rgb_to_r_g_b(clock_colour,clock_alpha))
  cairo_stroke(cr)

  --Draw minute hand
  xm=xc+0.95*clock_r*math.sin(mins_arc)
  ym=yc-0.95*clock_r*math.cos(mins_arc)
  cairo_move_to(cr,xc,yc)
  cairo_line_to(cr,xm,ym)
  --
  cairo_set_line_width(cr,3)
  cairo_stroke(cr)

  -- Draw seconds hand
  if show_seconds then
    xs=xc+1.1*clock_r*math.sin(secs_arc)
    ys=yc-1.1*clock_r*math.cos(secs_arc)
    cairo_move_to(cr,xc,yc)
    cairo_line_to(cr,xs,ys)

    cairo_set_line_width(cr,1)
    cairo_stroke(cr)
  end
end

function DrawLine (cr,start_x,start_y,end_x,end_y,linewidth)
  -- set colour (r,g,b,alpha)
  cairo_set_source_rgba(cr,1,1,1,0.8)
  cairo_move_to(cr,conky_window.width - start_x,start_y)
  cairo_rel_line_to(cr,-end_x,end_y)
  cairo_set_line_width(cr,linewidth)
  cairo_stroke(cr)

end

function DrawBars (cr,start_x,start_y,bar_width,bar_height,corenum,r,g,b)
  -- set colour (r,g,b,alpha)
  cairo_set_source_rgba(cr,1,1,1,0.1)
  cairo_rectangle (cr,start_x,start_y,bar_width,-bar_height)
  cairo_fill(cr)
  cairo_set_source_rgba(cr,r,g,b,1)
  value = tonumber(conky_parse(string.format("${exec sensors | grep -o  'Core %s:        +[0-9].' | sed -r 's/%s:|[^0-9]//g'}",corenum,corenum)))
  max_value=100
  scale=bar_height/max_value
  indicator_height=scale*value
  cairo_rectangle (cr,start_x,start_y,bar_width,-indicator_height)
  cairo_fill (cr)
end


function conky_clock_rings()
  local function setup_rings(cr,pt)
  local str=''
  local value=0

  str=string.format('${%s %s}',pt['name'],pt['arg'])
  str=conky_parse(str)

  value=tonumber(str)
  if value == nil then value = 0 end


  if pt['arg'] == "%I.%M"  then
    value=os.date("%I")+os.date("%M")/60
    if value>12 then value=value-12 end
  end

  if pt['arg'] == "%M.%S"  then
    value=os.date("%M")+os.date("%S")/60
  end

  pct=value/pt['max']
  draw_ring(cr,pct,pt)
end

--Check that Conky has been running for at least 5s
  if conky_window==nil then return end
  local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

  local cr=cairo_create(cs)

  local updates=conky_parse('${updates}')
  update_num=tonumber(updates)

  if update_num>5 then
    for i in pairs(settings_table) do
      setup_rings(cr,settings_table[i])
    end
  end

  --parse in arguments as so (cr,startx postion,starty postion, how much to move x, how much to move y)
  DrawLine(cr,0,0,343,0,8)
  DrawLine(cr,343,0,0,25,4)
  DrawLine(cr,100,75,170,0,4)

  --draw network lines
  DrawLine(cr,398,155,0,23,4)
  DrawLine(cr,0,155,400,0,4)
  --draw cpu temp bars
  DrawBars(cr,250,470,30,100,0,rgb_to_r_g_b(0x607d8b))
  DrawBars(cr,290,470,30,100,1,rgb_to_r_g_b(0x3f51b5))
  DrawBars(cr,330,470,30,100,2,rgb_to_r_g_b(0x00796b))
  DrawBars(cr,370,470,30,100,3,rgb_to_r_g_b(0xe53935))
  --draw cpu temp lines
  DrawLine(cr,0,320,348,0,4)
  DrawLine(cr,348,318,0,26,4)
  --draw mem lines
  DrawLine(cr,0,585,144,0,4)


  draw_clock_hands(cr,clock_x,clock_y)
end
