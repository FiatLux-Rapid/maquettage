### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 0256ecd1-2578-446a-bae5-81e7b7505a1f
using PyCall

# ╔═╡ 01d6cad1-6ae7-4b83-b588-3454ef04ed07
using Images

# ╔═╡ e0c21f96-4a21-4b34-a681-74b4ab0f8267
using FileIO

# ╔═╡ 5780387b-68ae-409d-b5aa-120f00456f6e
begin
	using ModelingToolkit
	using BasicBSpline
	using Plots
	#using BasicBSplineExporter
	using StaticArrays
	using QuadGK
	using IfElse
	using DifferentialEquations
	using DataInterpolations
	using Interpolations
	using Sobol
	using PlutoUI
end

# ╔═╡ b221a55a-566d-4922-97ba-e8c53b707075
using  Statistics

# ╔═╡ 35814a22-4025-410a-87ec-1b07cc194819
using Roots

# ╔═╡ 90d62c35-1a45-4d66-8f53-1c5ab8278c35
200*99

# ╔═╡ 52524ce7-9b8f-44c9-beb0-684610d62596
 (137-99.2)/21.9*37 +99.2

# ╔═╡ f6437078-4ac7-49b4-9ae2-f9bb2b70c9ed


# ╔═╡ fa8c9d92-3fee-41ac-a9f5-c217b56db62b

begin
	py"""
import schemdraw
import schemdraw.elements as elm
with schemdraw.Drawing(file='schematic.png',show=False,unit=2) as d:
	d.push()
	R1 = d.add(elm.Resistor(d='down', label='20$\Omega$'))
	V1 = d.add(elm.SourceV(d='down', reverse=True, label='120V'))
	d.add(elm.Line(d='right', l=3))
	d.add(elm.Dot())
	d.pop()
	d.add(elm.Line(d='right', l=3))
	d.add(elm.Dot())
	d.add(elm.SourceV(d='down', label='60V', reverse=True))
	d.add(elm.Resistor(label='5$\Omega$'))
	d.add(elm.DOT())
	d.add(elm.Line(d='right', l=3))
	d.add(elm.SourceI(d='up', label='36A'))
	d.add(elm.Resistor(label='10$\Omega$'))
	d.add(elm.DOT())
	d.add(elm.Line(d='left', l=3, move_cur=False))
	d.add(elm.Line(d='right', l=3))
	d.add(elm.DOT())
	R6 = d.add(elm.Resistor(d='down', toy=V1.end, label='6$\Omega$'))
	d.add(elm.DOT())
	d.add(elm.Line(d='left', l=3, move_cur=False))
	d.add(elm.Resistor(d='right', xy=R6.start, label='1.6$\Omega$'))
	d.add(elm.Dot(label='a'))
	d.add(elm.Line(d='right'))
	d.add(elm.Dot(label='b'))


		"""
load("D:/2022/FIATLUX_Implementation/NotebooksPluto/schematic.png")
end

# ╔═╡ a5582ae8-84d1-476d-a54b-d3401d55bd21
	

# ╔═╡ 0ef3a551-7cb9-4902-ba7e-f295d0624056
# Creation d'un composant
begin
	function create(;name,ctype,value=0,inival=0)
		res=[]
		
		if ctype=="R"	
		push!(res,eval(Meta.parse("@named "*name*"=Resistor(R="*string(value)*")")))
		push!(res,"d += elm.Resistor().label('"*name*"\n "*string(value)*" Ω')")	
		elseif ctype=="C"	
		push!(res,eval(Meta.parse("@named "*name*"=Capacitor(C="*string(value)*")")))
		push!(res,"d += elm.Capacitor().label('"*name*"\n "*string(value*1e6)*"µF')")	
		elseif ctype=="S"	
		push!(res,eval(Meta.parse("@named "*name*"=Switch0()")))
		push!(res,"d += elm.Switch().label('"*name*"')")	
			push!(res,"error")
		end
		return res
	end
end

# ╔═╡ fcc53f24-fac1-4608-a652-e2f839633981
begin
	str=""
	#tsd=nothing
	mycrea=create(name="tst",ctype="R",value=3)
	tst=mycrea[1]
	#push!(str,mycrea[2])
	str*=mycrea[2]
	str*=";"
	mycrea=create(name="tst1",ctype="S",value=2.5)
	tst1=mycrea[1]
	#push!(str,mycrea[2])
	str*=mycrea[2]
end

# ╔═╡ 23a4002a-0275-4ea8-aee1-ebeb02d73b0b
str

# ╔═╡ b8f00012-3e19-44e4-a931-297515180096
#= in fiatlux env:
import Pkg
Pkg.build("PyCall")
rerun Julia
=#
sd = pyimport("schemdraw")

# ╔═╡ 42cf12c4-6b78-40a6-a82d-a08b4d2453a4
elm=pyimport("schemdraw.elements")

# ╔═╡ f4a47652-7228-4314-bd75-4ba48a433583
begin
	active=1
	py"""
	import schemdraw
	import schemdraw.elements as elm
	with schemdraw.Drawing(file='schematic.png',show=False) as d:
	    d+= elm.Resistor().label('tst\n 3 Ω');d += elm.Switch().label('tst1')
	"""
	#=
	 d += elm.Resistor().label('tst\n 0');d += elm.Resistor().label('tst1\n 3')
	    d += elm.Resistor().label('tsd\n 0')
	    d += elm.Capacitor().down().label('0.1μF', loc='bottom')
	    d += elm.Coax().left()
	   # d += elm.Line()
	    d += elm.SourceV().up().label('10V')
	=#
	
end

# ╔═╡ 51a88907-2ff2-41c7-a87f-53b335e614e9
py"$str"

# ╔═╡ fc744923-b5a0-440d-a82f-273e455d9763


# ╔═╡ f55b1cdd-c9e8-43af-b4f7-a5491dbe5f3a
tst

# ╔═╡ 133ae137-789a-459d-8288-9b41f725077a
str

# ╔═╡ 0e0e94f8-23d1-4380-8c3a-d6b61b58c629
begin
	active
load("D:/2022/FIATLUX_Implementation/NotebooksPluto/schematic.png")
end

# ╔═╡ 0e73fa0c-7373-451e-88aa-b92542741f5a
md"""
### Image

![alt text]("schematic.svg") 
"""

# ╔═╡ aaf43df2-25e5-4117-a454-84b43613d70f
html"""
 <p>Simple Image Insert</p>
      <img src = "D://2022//FIATLUX_Implementation//NotebooksPluto//schematic.svg" alt = "Test Image" width = "240" height = "124"  border = "5" align = "left"/>
	    
"""

# ╔═╡ 01ef2187-85b6-4cf6-97ed-756faeb06732
pwd()

# ╔═╡ 41851e9a-e072-49c8-87f1-736573e44027
@macroexpand @asynclog

# ╔═╡ ffaba1f2-2de4-4eab-8317-02129643436a
begin
	#cahier des charges LPGP
	vlp=5e3
	clp=200e-12
	enlp=0.5*vlp^2*clp
	prflp1=2e4
	eavlp=prflp1*enlp
	ilp=vlp/50
	vfinch=0.5*ilp*5e-9/clp
	2.2*50*clp     #v=0 en c ouvert  front descente passe à zéro en 5ns décharge c dépend l c du réacteur
end

# ╔═╡ 94883e3f-eef1-4ce0-94e3-eb7db119444f
1begin
	plot()
	tspan0=20e-8
	@named vet=Capacitor(C=1e-7)
	@named swet=Switch0(ton=10.0e-9,toff=35e-9) #SwitchET(ton=10.0e-9,toff=35e-9)
    @named swcc0=Switch0(ton=215e-9,toff=35e-9)
	@named swcb0=Switch0(ton=235e-9,toff=1)
	@named linenan0=Line(clength=3,nloop=10)
	@named lnan0=Inductor(L=0.1e-9)
	@named coutnan0=Capacitor(C=200e-12)
	@named gnan0=Ground()
	@named rcb0=Resistor(R=50)
	@named diodeet0=Diode()

	eqnet=[connect(vet.p,swet.p,diodeet0.n)
			connect(swet.n,diodeet0.p,swcc0.p,swcb0.p,linenan0.l_1.p)
			connect(linenan0.c_10.p,lnan0.p)
			connect(lnan0.n,coutnan0.p)
			connect(swcb0.n,rcb0.p)
			connect(rcb0.n,coutnan0.n,vet.n,swcc0.n,gnan0.g,linenan0.c_1.n)]
	#=eqnet=[connect(vet.p,swet.sw.p,diodeet0.n)
			connect(swet.l.n,diodeet0.p,swcc0.p,swcb0.p,linenan0.l_1.p)
			connect(linenan0.c_10.p,lnan0.p)
			connect(lnan0.n,coutnan0.p)
			connect(swcb0.n,rcb0.p)
			connect(rcb0.n,coutnan0.n,vet.n,swcc0.n,gnan0.g,linenan0.c_1.n)]
=#
	
	 @named _nano_et = ODESystem(eqnet, t)
     @named nano_et = compose(_nano_et,[vet,swet,swcb0,swcc0,gnan0, linenan0,lnan0,rcb0,coutnan0,diodeet0])
     syset= structural_simplify(nano_et)
	 u0et = [vet.v=>4.9e3
		     #swet.c.v=>4.9e3
	        ]
     probset = ODAEProblem(syset, u0et, (0, tspan0))
     solet = solve(probset, Tsit5(),tstops=collect(0:1e-9:tspan0))
	# plot(solet,idxs=[swet.v])
end

# ╔═╡ d0106796-0845-4cfc-be01-3caeff9a78b0
plot(solet,idxs=[vet.v],xlimits=(0,tspan0))

# ╔═╡ d2cf41ab-4df8-4c6e-8c25-9403cbd610ce
swet.sw.p

# ╔═╡ 6b8e138f-b744-420c-8f95-8760cff55531
begin
	ids=1e-6
	nbv=0.74
	vt=40
	ibv=0.7
	bv=5e3
    
	i(v)=ids*(exp(v/vt)-1)-ibv*(exp(-(v+bv)/(nbv*vt)))

	tvec = range(-8500,1000, length = 1000)

    plot(tvec,i.(tvec))# ,ylimits=(-10000000,10))
	
end


# ╔═╡ 99a48120-9d55-4a6a-b106-87ffd20b4b7a
vcat([connect(sw.p,c.p),connect(sw.n,l.p,c.n), i ~ sw.p.i,v ~ sw.v + l.v])

# ╔═╡ 8cfe53e5-e048-4fab-bc7e-99f66529374c
i.(tvec)

# ╔═╡ 150b5531-4b61-4162-9889-577e74494a34
#@named myet=SwitchET(ton=5e-9,toff=15e-9,prf=1e5,ron=1e-3,roff=1e6,Vmax=5e3)  

# ╔═╡ cde0d9ab-66c0-48d6-aa3e-90451479aa53
#myet.sw.p

# ╔═╡ 9069d415-d9c3-43d1-91bc-9b19f2bf4778
#nanopulse
1begin
	zener=false
	lc=true
	tonnan=0e-9
	toffnan=30e-9
	tspan=6e-8
	@named vinnan=Capacitor()
	if zener | lc
		@named swonoff=SwitchET(ton=tonnan,toff=toffnan)
	else
		@named swonoff=Switch0(ton=tonnan,toff=toffnan)
	end
	@named swcc=Switch0(ton=1,toff=toffnan)
	@named swcb=Switch0(ton=35e-9,toff=1)
	@named linenan=Line(clength=3,nloop=10)
	@named lnan=Inductor(L=1e-9)
	@named coutnan=Capacitor(C=40e-12)
	@named gnan=Ground()
	@named rcb=Resistor(R=50)
	@named rin=Resistor(R=1)
	if zener
		eqnan=[connect(vinnan.p,swonoff.sw.p)
			connect(swonoff.sw.n,swcc.p,swcb.p,linenan.l_1.p)
			connect(linenan.c_10.p,lnan.p)
			connect(lnan.n,coutnan.p)
			connect(swcb.n,rcb.p)
			connect(rcb.n,coutnan.n,vinnan.n,swcc.n,gnan.g,linenan.c_1.n)]
	else
		eqnan=[connect(vinnan.p,swonoff.p)
			connect(swonoff.n,swcc.p,swcb.p,linenan.l_1.p)
			connect(linenan.c_10.p,lnan.p)
			connect(lnan.n,coutnan.p)
			connect(swcb.n,rcb.p)
			connect(rcb.n,coutnan.n,vinnan.n,swcc.n,gnan.g,linenan.c_1.n)]
	end
	 @named _nano_model = ODESystem(eqnan, t)
     @named nano_model = compose(_nano_model,[vinnan, swonoff,swcc,swcb,linenan, lnan,coutnan,gnan,rcb,rin])
     sysnan = structural_simplify(nano_model)
	if zener 
		u0nan = [vinnan.v=>4.9e3
	          ]
	else
		u0nan = [vinnan.v=>5e3
	    swonoff.v=>5000.0]
	end
     probsnan = ODAEProblem(sysnan, u0nan, (0, tspan))
     solnan = solve(probsnan, Tsit5(),tstops=collect(0:1e-9:tspan))
	if zener 
		plot(solnan,idxs=[swonoff.sw.v],ylimits=(0,6000))
	else
		plot(solnan,idxs=[swonoff.v],ylimits=(0,6000))
	end
end

# ╔═╡ 9cc65cde-10e5-4693-9d91-127d741dee60
plot(solnan,idxs=[swonoff.v],xlimits=[14e-9,20e-9],ylimits=(0,6e3))

# ╔═╡ fbde6c7a-7c97-4cfa-b242-c5f413d20ccb
plot(solnan,idxs=[swcb.v,swcc.v,swonoff.v],ylimits=[0,6e3],xlimits=[0,100e-9])

# ╔═╡ 6396647a-10c9-4635-9fcb-a8bf0032b2ae
@macroexpand @named s_model = compose([], [],swtest8_c)

# ╔═╡ a69d27dd-3854-45c0-baf9-808c5966f028
# créalion d'un composant (commutateur avec R,L,C) par métaprogrammation
begin
	
	#=
	vmax=5e3
	#imax=100
	function makeSwitch(;name="sw",tons=5e-9,toffs=15e-9,prf=1e5,vmaxs=5e3,imaxs=100,trs=5e-9,tfs=5e-9,rons=1e-3,roffs=1e6)
	lsw=vmaxs*trs/imaxs
	csw=imaxs*tfs/vmaxs
	cn=string(name)*"_c"
	ln=string(name)*"_l"
	sn=string(name)*"_s"
   
		try
			eval(Meta.parse(cn*"=nothing"))
		catch
		end
		try
			eval(Meta.parse(ln*"=nothing"))
		catch
		end
		try
			eval(Meta.parse(sn*"=nothing"))
		catch
		end
		cn
    myname=   string.([cn*" =Capacitor(name=:"*cn*",C="*string(csw)*")"
		,"@named "*ln*" =Inductor(L="*string(lsw)*")",		
	" @named "*sn*" =Switch0()"
	])
		
 
	
   
		mypar="ps = @parameters vmaxs="*string(vmaxs)*" imaxs="*string(imaxs)* " trs= "*string(trs)*" tfs="*string(tfs)*" rons="*string(rons)* " roffs="*string(roffs)
	

		myeq=string.(["connect("*sn*".p,"*cn*".p)",
	"connect("*sn*".n,"*cn*".n,"*ln*".p)"])
	myini=string.([cn*".v=>0.0",ln*".i=>0.0"])
		
	
	
			[eval.(Meta.parse.(myname)),mypar,myeq,myini]
		
	end
	swname="swtest8"
# delete switch if needed
	
	delstr=swname*"_l=nothing;"*swname*"_c"*"=nothing;"*swname*"_s=nothing;"*swname*"=nothing"
	# copy from delstr
	#swtest8_l=nothing;swtest8_c=nothing;swtest8_s=nothing;swtest8=nothing
#make new
	newswitch=makeSwitch(name="swtest8")
	swtest8=newswitch[1]
	psstr=newswitch[2]
	myeq=newswitch[3]
	myini=newswitch[4]
	=#
end

# ╔═╡ 8e853c52-6052-4e04-9174-f8910b3535e4
couts

# ╔═╡ eb6e2fb7-4ebf-4fd1-b7bd-c9755ef8dc25
myini

# ╔═╡ e654db9f-1b14-43a1-b33b-d3c05427bd15
delstr

# ╔═╡ 1b3a2d5a-2871-4952-b1ef-ce21e02f7e16


# ╔═╡ 27b3d354-17f8-45fb-bc40-98e92e13175d
#simple circuit
1begin
	 @named diod=Diode()
	 @named cbdiod=Diode()
	 @named grds=Ground()
	 @named vins=Capacitor(C=1)  #ConstantVoltage(V=5e3) 
	 @named couts=Capacitor(C=40e-12)
	 @named csw=Capacitor(C=1e-12)
	 @named cpar=Capacitor(C=400e-12)
	 @named lsw=Inductor(L=160e-9)
	 @named sw=Switch0(ton=5e-9,toff=20e-9) #Switch0(;name,ton=5e-9,toff=15e-9,prf=1e5,ron=1e-3,roff=1e6)
	 eqss=
		  [connect(vins.p,sw.p,csw.p)
		   connect(lsw.p,sw.n,csw.n,cpar.p) 
		  connect(lsw.p,cbdiod.n)
		   connect(lsw.n,diod.p)
		   connect(diod.n,couts.p)  
		   connect(vins.n,couts.n,grds.g,cpar.n,cbdiod.p)  
		  ]
	
     @named _s_model = ODESystem(eqss, t)
     @named s_model = compose(_s_model,
                          [grds,vins,couts,csw,lsw,sw,cpar,diod,cbdiod])
     syss = structural_simplify(s_model)
     u0s = [
      vins.v => 5.0e3
	  couts.v=>0.0
	  csw.v=> 5e3
	  lsw.i=>0.0
	  #sw.v=>5e3
     ]
     probs = ODAEProblem(syss, u0s, (0, 10e-8))
     sols = solve(probs, Tsit5(),tstops=collect(0:0.1e-9:10e-8))
     plot(sols,idxs=[sw.v],tstops=collect(0:1e-9:2e-8),xlimits=[0,20e-9],ylimits=[0,200])
	
	#=
	  @named grds=Ground()
	  @named vins=Capacitor()  #ConstantVoltage(V=5e3) 
	  @named couts=Capacitor(C=40e-12)
      psimple = @parameters vmaxs=5000.0 imaxs=100 trs= 5.0e-9 tfs=5.0e-9 rons=0.001 roffs=1.0e6
	  eqss=vcat(
		  [connect(vins.p,swtest8_s.p)
		  connect(swtest8_l.n,couts.p)
		  connect(couts.n,vins.n,grds)], eval.(Meta.parse.(myeq))
			  )
	simple_model = compose(ODESystem(eqss, t,[],psimple;name=:simple_model),grds,vins,couts) 
	#;discrete_events=discrete_events)
   
	@named s_model = compose(simple_model,swtest8_c)
	ini0=[]
	push!(ini0,vins.v=>5e3)

	push!(ini0,swtest8_c.v=>0.0)
    push!(ini0,swtest8_l.i=>0.0)
	ini0=convert(Vector{Pair{Num, Float64}},ini0)
	
    simple_simplified = structural_simplify(simple_model)
	#=
	simple_prob = ODAEProblem(simple_simplified, ini0, (0.0, 1.e-8))
	
	sol_simple = solve(simple_prob, Tsit5()) #,tstops=tstop0lp,saveat=tstop0lp)
	=#
	=#  
end

# ╔═╡ 6da39121-212d-4da7-b553-d2ac0ac3cbdd
typeof(eqss)

# ╔═╡ 982b9ac0-decc-440e-9bb2-bd339e050205
csw

# ╔═╡ 7b1038bf-f9f2-4bc3-b2c8-2e6d6eeea5d6
     plot(sols,idxs=[couts.v],tstops=collect(0:1e-9:20e-8),xlimits=[4e-9,17.0e-9])

# ╔═╡ 9189815a-b0df-4ec8-ad88-7243a90af633
     plot(sols,idxs=[sw.i],tstops=collect(0:1e-9:1e-8),xlimits=[4.99e-9,5.01e-9])

# ╔═╡ ca0a1d99-d7d1-43be-a848-e1e0cb5523f1
simple_model

# ╔═╡ 6a6213da-ba58-4cc6-be66-70115373dcf4
swtest8_c

# ╔═╡ ae16a06c-758f-46f7-9747-9f9a0d456765
typeof(swtest8_c)==typeof(couts)

# ╔═╡ 2ea396d1-521f-498e-afeb-4e57d3874cfe


# ╔═╡ d72dbf23-16fb-4d47-a575-4ea0302d79ac
eqss

# ╔═╡ 06969a97-ef8d-4b1b-9a12-029c258a09d8
simple_simplified 

# ╔═╡ 25896eac-e7a0-4f15-ac8e-748714882e95
psstr

# ╔═╡ 81428a64-3a4e-49fe-a82f-cd268fb0b57e
begin
	vmax=5e3
	imax=100
	
	pséé=nothing
eval(Meta.parse("ps = @parameters "*vmaxs*"=vmax "*imaxs*"=imax "*trs*"=tr "*tfs*"=tf "*rons*"=ron "*roffs*"=roff))
end

# ╔═╡ 73170584-e179-4b59-84a1-103361b66da0
tr

# ╔═╡ ae13b006-a982-4848-8846-69236a933829
swtest_c

# ╔═╡ 09d4f87a-4e71-4257-92d5-f0a124acf5d6
#@named mysw1=Switch()

# ╔═╡ feeeb754-fe3f-4766-aa8f-1a7f488a0929
mysw1.sw.p.v

# ╔═╡ 5a36c4c1-f33c-49fa-a362-df995c8752f5
mysw.p

# ╔═╡ 26353eee-7824-4e81-ad23-41ddf666f9f9
#Chargement par induction et décharge RLC

# ╔═╡ a3ac0de9-0b2f-4652-90f8-a22a9093a991
linelength=3

# ╔═╡ aa5070f3-013a-4c4f-a838-9a480c5b63e5
connexion="coax"

# ╔═╡ 2b845e22-f75a-4949-a0fe-9df7462da0f3
nloopini=30

# ╔═╡ 23b8f517-f1ed-47fc-a802-21029162747e
begin
	
	
	capaload=40e-12
	inducload=40e-9
	Clp=capaload
	
	Vlp=5000
	swonlp=5e-9
	rtlp=5.0e-9
	twidthlp= 20e-9 #   1/2/flp# +2.5e-9
	#https://www.translatorscafe.com/unit-converter/fr-FR/calculator/coaxial-cable/?wd=0.9&wdu=mm&sd=3.15&sdu=mm&mt=3
    twidth=twidthlp
	Llp=inducload

	omegalp=1/(Llp*Clp)^0.5
	flp=omegalp/2/π
	trlind=0.35/flp
	dampcoef=  50/(2*(Llp/Clp)^0.5 )
	Rlp=dampcoef*2*(Llp/Clp)^0.5 #   5e-9/Clp/2.2
	
	
	Ilp=120
	
	tlpc=Clp*Vlp/Ilp*2
	tlpl=Llp*Ilp/Vlp
	
	
	
	tlpc,tlpl,Rlp,0.35/flp,1/2/flp,Llp
	
	
end

# ╔═╡ 4eb2aeb6-373a-4dd4-aabb-fefae4f2ce1c
Rlp

# ╔═╡ e1978f58-d6ba-42ea-a9ca-f34a07e99d68
1begin
	#LPGP project
	
	Coutlp=Clp
	Cinlp=1000*Coutlp
	

	
	ronlp=1e-3
	rofflp=1e5
	prflp=15e3
	crbtofflp=swonlp+twidthlp+rtlp
	nbmacropulselp=1
	#imaxlp=200
    
    @named vinlp=Capacitor(C=Cinlp)  #ConstantVoltage(V=5e3) 
	@named coutlp=Capacitor(C=Coutlp)  #ConstantVoltage(V=5e3)
	
	
	@named pulselp=Switch(;ron=0.01,roff=1e6)
	
	#@named pulselp= switchilimit(ton=swonlp,twidth=twidthlp,rt=rtlp,ron=ronlp,roff=rofflp,prf=prflp,ilimit=200)
	#@named pulselp= BiswitchET(ton=swonlp,twidth=twidthlp,rt=rtlp,ron=ronlp,roff=rofflp,prf=prflp)
	#@named pulselp= switchl(ton=swonlp,twidth=twidthlp,vmax=5e3,ilimit=100,tr=rtlp,ron=ronlp,roff= rofflp,prf=prflp)

	@named cbswlp=Switchrec(ton=crbtofflp,toff=1.0,ron=Rlp,roff=rofflp,prf=prflp) 

	#@named cbswlp= switchilimit(ton=crbtofflp,twidth=10*twidthlp,rt=rtlp,ron=Rlp,roff=rofflp,prf=prflp,ilimit=200)
	#@named cbswlp=Switchrec(ton=crbtofflp,toff=1.0,ron= Rlp,roff=rofflp,prf=prflp)
    #@named cbswlp= switchl(ton=crbtofflp,twidth=10*twidthlp,vmax=5e3,ilimit=100,tr=rtlp,ron=Rlp,roff= rofflp,prf=prflp)

	
	
	@named rcircuitlp=Resistor(R=5e3)

	if connexion =="coax"
		@named llp=line(name="llp")
		@named llp1=Inductor(L=inducload)
	else
		@named llp=Inductor(L=inducload)
	end
	@named glp=Ground()
	@named llpsw=Inductor(L=15e-8)
	tstop0lp=[]
	for i in 0:(crbtofflp+rtlp+30e-9)*1e9
		push!(tstop0lp,i*1e-9)
	end


	if connexion =="coax"
		lprc_eqs = [
	          connect(vinlp.p, pulselp.swin.p)
			#connect(vinlp.p, pulselp.p)
			 connect(pulselp.swout.n,  cbswlp.p,llpsw.p)
	       # connect(pulselp.n,  cbswlp.p,llpsw.p)
			  connect(llpsw.n,llp.li_1.p)
			  connect(llp.cout.p,llp1.p)
			  connect(llp1.n,coutlp.p,rcircuitlp.p)
	          connect( glp.g,vinlp.n,cbswlp.n,coutlp.n,rcircuitlp.n,llp.ci_1.n)
	         ]
	else

		lprc_eqs = [
	          connect(vinlp.p, pulselp.p)
			  connect(pulselp.n,  cbswlp.p,llp.p)
			  connect(llp.n,coutlp.p,rcircuitlp.p)
	          connect( glp.g,vinlp.n,cbswlp.n,coutlp.n,rcircuitlp.n)
	         ]
	end

	
	
	@named lp_rc_model = ODESystem(lprc_eqs, t) #;discrete_events=discrete_events)
	
	
	if connexion =="coax"
		@named lprc_model = compose(lp_rc_model, [glp,rcircuitlp,vinlp,cbswlp,pulselp,coutlp,llp,llp1,llpsw])
	else
		@named lprc_model = compose(lp_rc_model, [glp,rcircuitlp,vinlp,cbswlp,pulselp,coutlp,llp,llpsw])
	end

		lpu0=[ ]
		push!(lpu0,coutlp.v=>0.0)
	    push!(lpu0,vinlp.v=>Vlp)
	    push!(lpu0,llpsw.p.i=>0.0)
	   #  push!(lpu0,pulselp.cswp.v=>0.0)
	#push!(lpu0,pulselp.swout.i=>0.0)
	
	   
	   
	if connexion =="coax"
		push!(lpu0,llp.li_1.p.i=>0.0)
		push!(lpu0,llp1.i=>0.0)
	else
		push!(lpu0,llp.i=>0.0)
	end
        lpu0=convert(Vector{Pair{Num, Float64}},lpu0)
		lpsys = structural_simplify(lprc_model)
	
		lpprob = ODAEProblem(lpsys, lpu0, (0.0, (nbmacropulselp-1)/ prflp+crbtofflp+45e-9))
	
	lpsol = solve(lpprob, Tsit5(),tstops=tstop0lp,saveat=tstop0lp)
	    nothing
	   #[swonnp,swtoff+swtrnp,crbswtoffnp1]) 
	   plot(lpsol,idxs=[coutlp.v],tspan=(linelength*5e-9,(nbmacropulselp-1)/prflp+crbtofflp+40e-9),tstops=tstop0lp )
	
	
end

# ╔═╡ 2f457efa-4df1-4def-8578-564c493e2400
Rlp

# ╔═╡ b59a09fa-9e12-4e6c-8d02-45d5664f4d46
dampcoef*2*(Llp/Clp)^0.5

# ╔═╡ 107fb85f-96c0-441c-a7d9-53bd4f2c2c7e
states(lpsys)

# ╔═╡ 079bddd7-bddc-4a21-ba0e-4185753c6f83
lpsol[coutlp.p.v]

# ╔═╡ d37b98eb-92ed-4293-a616-14df794db177
coutlp.p.v

# ╔═╡ 230a1baf-e984-4dde-8db1-85387945c8d5
begin
	#plot(lpsol,idxs=[cbl.v],xlimits=(0,60e-9))
 plot(lpsol,idxs=[pulselp.i,cbswlp.p.i],xlimits=(0,60e-9))
end

# ╔═╡ 46d28b70-0152-49b9-8d08-457b5bde1885
plot(lpsol,idxs=[pulselp.v,cbswlp.v])

# ╔═╡ da4edb5e-aa4b-4f91-89ea-08c8b3240d86
2e3*200e-12/5e-9

# ╔═╡ e75b4b50-ce81-4a0b-bc54-e76e3e85fa27
npprob

# ╔═╡ b179584b-d9c9-4ba2-b069-af55726f9b71
md"""
## Plan de travail
- switch avec capacité parasite/masse & inductance et transil si surtension
- interpolation de i(t) des diodes 
- calcul du timing pour un cahier des charges nanopulse donné   DONE 
- calcul des pertes thermiques, Vmav irms etc..   Done.
_ ground specifique au projet  DONE
"""

# ╔═╡ e54caf42-3978-4dd8-b4c4-16b1440b5a53


# ╔═╡ ff94f32d-96f2-4243-9118-4fe9a449e31d
begin
		function bir_switch(t;ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,prf=prf)
				local trec=  mod(t,1/prf)
			IfElse.ifelse(trec<=ton,
				   	roff,
				   	IfElse.ifelse(trec<=ton+rt,
				   			(ron-roff)/rt*trec+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(trec<=ton+twidth, 
								ron,
								IfElse.ifelse(trec<ton+twidth+rt,
					   				(roff-ron)/rt*trec+ron-(roff-ron)/rt*(ton+twidth),
									roff
								))))
		end
	

 bir_switch1(t)=bir_switch(t ;ton=swonnp,twidth=tpulsenp,rt=swtrnp,ron=1e-3,roff=1e6,prf=prfnp)
end

# ╔═╡ 1091a432-f576-4dab-b94a-3e9ca891eddf
plot(bir_switch1, 0e-9:0.1e-9:55e-9, label="impédance commutateur principal" )

# ╔═╡ eb987440-3e6e-485f-8915-8e00d60a518d
1begin
	prfnp=1e5  # pulse repetition frequency
	nbmacropulse=1
	tpulsenp=30e-9  # pulse duration
	typenp="monopolar"  # monopolar pulse other option bipolar pulse "bipolar" 
	nbpulsenp=1 # total number of number of pulses
	linelengthnp=linelength # in meter  5ns/m typical
	swonnp=5e-9 #10e-9 #5e-9  # initial delay
	swtrnp=5e-9  #rise and fall time
	swtoff=swonnp+tpulsenp
	swronnp=1e-3
	swroffnp=1e6
	crbr=IfElse.ifelse(typenp=="monopolar",swroffnp,IfElse.ifelse(typenp=="bipolar",1e-6,50))
	inouttime=6e-9*linelengthnp*2
	
	
	#crowbar commutes after initial pulse closing until n reflexion occurs 
	
	crbswtoffnp1=swtoff+swtrnp+inouttime*(nbpulsenp-1)    #+inouttime/2

	tstop0=[]
	for i in 0:((swtoff+swtrnp+inouttime*(nbpulsenp-1)+inouttime)*1e9)*2
		push!(tstop0,i*0.5e-9)
	end
  
    #@named nppulsesw=Switch1(ton=swonnp,toff=swtoff,ron=1e-3,roff=1e6)
   # @named nppulsesw=Switchrt(ton=swonnp,twidth=tpulsenp,rt=swtrnp,ron=1e-3,roff=1e6)
	@named nppulsesw=BiswitchET(ton=swonnp,twidth=tpulsenp,rt=swtrnp,ron=1e-3,roff=swroffnp,prf=prfnp)
	@named cbsw=Switchrec(ton=crbswtoffnp1,toff=1.0,ron= 50,roff=swroffnp,prf=prfnp)
	@named cbsw1=Switchrec(ton=swtoff,toff=crbswtoffnp1,ron=crbr,roff=swroffnp,prf=prfnp)

	
	@named linenp=line(name="linenp")
	@named vinnp=Capacitor(C=1)  #ConstantVoltage(V=5e3)    
	@named rcircuitnp=Resistor(R=5e3)
	
	@named gnp=Ground()
	@named vprobenp=VoltageSensor()
	
	nprc_eqs = [
	          connect(vinnp.p, nppulsesw.p,vprobenp.p)
			 # connect(nppulsesw.n,vprobenp.n,cbsw.p,cbsw1.p)
			  connect(linenp.cout.p,rcircuitnp.p)
			  connect(nppulsesw.n,vprobenp.n, linenp.li_1.p,cbsw.p,cbsw1.p)
	          #connect(nppulsesw.n,vprobenp.n, rcircuitnp.p,cbsw.p,cbsw1.p)
			  #connect(rcircuitnp.n, linenp.li_1.p) 
			 # connect(rcircuitnp.n, linenp.cout.n)
	          connect( gnp.g,vinnp.n,cbsw.n,cbsw1.n,linenp.ci_1.n,rcircuitnp.n)
	         ]
	
	@named np_rc_model = ODESystem(nprc_eqs, t) #;discrete_events=discrete_events)
	@named nprc_model = compose(np_rc_model, [gnp,rcircuitnp,vinnp,cbsw,cbsw1,nppulsesw,linenp,vprobenp])

		npu0=[ ]
		for i in 1:nloop-1	
			strnp="linenp.ci_"*string(i)*".v"
			pairnp=eval(Meta.parse(strnp*"=>0.0"))
			push!(npu0,pairnp)
		
			#npstr="npline.li_"*string(i)*".i"
			#nppair=eval(Meta.parse(npstr*"=>0.0"))
			#push!(u0np,nppair)
		end
		push!(npu0,linenp.cout.v=>0.0)
	    push!(npu0,vinnp.v=>5.0e3)
	    #push!(u0np,r50.v=>0.0)
	    #push!(u0np,swpulse.v=>2.5e3)
	    push!(npu0,linenp.li_1.i=>0.0)
	
        npu0=convert(Vector{Pair{Num, Float64}},npu0)
		npsys = structural_simplify(nprc_model)
	
		npprob = ODAEProblem(npsys, npu0, (0.0, (nbmacropulse-1)/ prfnp+crbswtoffnp1+3*inouttime ))
		npsol = solve(npprob, Tsit5(),tstops=tstop0,saveat=tstop0)
	    nothing
	   #[swonnp,swtoff+swtrnp,crbswtoffnp1]) 
	   plot(npsol,idxs=[linenp.cout.v],tspan=(0.0,(nbmacropulse-1)/prfnp+crbswtoffnp1+inouttime),tstops=tstop0) 
end

# ╔═╡ 171c1ae3-bbeb-4b94-8423-1c0f15cd15fe
begin
# Check variable
	npsol
	cheksolstr="npsol"
	checkvarstr= "linenp.cout" #"linenp.cout" #vinnp" #rcircuitnp" # #nppulsesw" #cbsw"  #linenp.cout"  #  nppulsesw "linenp.li_1"
	checkvar=eval(Meta.parse(checkvarstr))  #
	checksol=eval(Meta.parse(cheksolstr))  #
	plot(checksol,idxs=[checkvar.i,checkvar.v],layout = grid(2, 1), heights=[1 ,1],tstops=tstop0) #, xlimits=(25e-9,35e-9))
end

# ╔═╡ 52214a30-dbe3-4e77-a438-7053d6a3121a
plot(npsol,idxs=[nppulsesw.v],tscan=[0:0.5e-9:45e-9],tstops=tstop0)

# ╔═╡ 2fb93fd0-e233-4d29-b113-cfd11c122fd2
plot(npsol,idxs=[nppulsesw.i],tscan=[0:0.5e-9:45e-9],tstops=tstop0)

# ╔═╡ 4aee2978-8c7c-4c2a-9821-ef14722400ca
1.386*50*40e-12

# ╔═╡ c7daeaf9-904a-4cf4-8d57-868c1b0cc979
1begin
	Ls =3e-9 # Lp*(1-k^2)
	Lm = 3e-6 # Lp*k^2
	@named	ls =Inductor(L=Ls)
    @named	lm =Inductor(L=Lm)
    @named	transf=Transformer(ratio=1.0)
	@named groundp=Ground()
	@named grounds=Ground()

	rc_eqs1 = [
          connect(ls.n, lm.p)
		  connect(lm.n, groundp.g,transf.tp.n)
		  connect(lm.p,transf.tp.p)
          connect(transf.ts.n,grounds.g)
         ]
		
@named tr = compose(ODESystem(rc_eqs1,t,name=:tr),lm,ls,transf,grounds,groundp)
	nothing
end

# ╔═╡ 9ba3e523-5b6d-4d28-81a5-ed1ef212f781
begin
		rc_eqs3=[]
		try
			for i in 1:nloop-1
				push!(rc_eqs3,connect(li[i].p,ci[i].p,li[i+1].p))
			end
		catch
		end

		for i in 2:nloop-1
			push!(rc_eqs3,connect(ci[i].n,ci[1].n))
		end
		

end

# ╔═╡ d34ff992-dbc5-4a65-8191-0f671f20d455
1begin

	#circuit
	Cz=1.0
	Vz=1.0

	#configuration du switch "resistorz"
	tonz=2
	
	roffz=1e6
	rini=1e6
	toffz=5
	@named resistorz = Switch1(ton=tonz,toff=toffz,ron=1e-3,roff=1e6)
	#tₒₙ=[ton] =>[resistorz.rsw ~ ron]    #ODESYSTEM discrete_event=[tₒₙ,tₖ]
	#tₖ=[toff] =>[resistorz.rsw ~ roff]
	#pevt=[resistorz.rsw=>roff]          # ODAEProblem(sysz,u0z, (0, 20),pevt)
	#resistorz₊rsw(t)=IfElse.ifelse(t<=ton,rini,IfElse.ifelse(t<=toff,ron,roff))
	
	@named capacitorz = Capacitor(C=Cz)
	@named sourcez = ConstantVoltage(V=Vz)
	@named groundz = Ground()
	rc_eqsz = [
	          connect(sourcez.p, resistorz.p)
	          connect(resistorz.n, capacitorz.p)
	          connect(capacitorz.n, sourcez.n)
	          connect(capacitorz.n, groundz.g)
	         ]


	#résolution
	#@named _rc_modelz = ODESystem(rc_eqsz, t,[],[];discrete_events=[tₒₙ,tₖ])
    @named _rc_modelz = ODESystem(rc_eqsz, t,[],[])
	@named rc_modelz = compose(_rc_modelz,
	                          [resistorz, capacitorz, sourcez, groundz])
	sysz = structural_simplify(rc_modelz)
	u0z = [
	      capacitorz.v => 0.0
		 
	     ]
	probz = ODAEProblem(sysz,u0z, (0, 20))
	#probz = ODAEProblem(sysz,u0z, (0, 20),pevt)
	solz = solve(probz, Tsit5(),tstops=[tonz,toffz])
	plot(solz)
	
end

# ╔═╡ d4890103-c2ef-4d19-a766-abb6cb5d319c
equations(sysz),observed(sysz),states(sysz),parameters(sysz),full_equations(sysz)

# ╔═╡ 740f22e3-35ce-4c75-aab6-8a913d688cf1
md"""
## Sampling and twins
"""

# ╔═╡ e1506254-49e3-46c7-b407-900bab0167a2
begin
	

tz = 0:0.05:1
x = sin.(2π*tz)
y = cos.(2π*tz)
A = hcat(x,y)

itp = Interpolations.scale(interpolate(A, (BSpline(Cubic(Natural(OnGrid()))), NoInterp())), tz, 1:2)

tfine = 0:.001:1
xs, ys = [itp(t,1) for t in tfine], [itp(t,2) for t in tfine]
	scatter(xs, ys)
	scatter!(x,y)
end

# ╔═╡ a295d5b2-1e24-49d9-9312-8d0b4c58bafe
begin
	lb=[90e3,0.00]
	ub=[200e3,1]
s1 = SobolSeq(lb, ub)
skip(s1, 5000)
p1 = reduce(hcat, next!(s1) for i = 1:67)'
	
#subplot(111, aspect="equal")
scatter(p1[:,1], p1[:,2])
	x1 = next!(s1)
#scatter!(x1)	
	scatter!([x1[1]], [x1[2]], color = "green", label = "next", markersize = 5)
end

# ╔═╡ 796f8d72-437c-4c71-b24a-cf63625ef0db
begin
	mind=[]
	for i in 1:size(p1)[1]
		push!(mind,(((p1[i,1]-x1[1])/(ub[1]-lb[1]))^2+((p1[i,2]-x1[2])/(ub[2]-lb[2]))^2)^0.5 )
	end
	nearpoint=p1[findmin(mind)[2],:]
end

# ╔═╡ f5f9aa89-6842-4e50-a85f-eeeafb613a1f
md"""
## Electronic components database
"""

# ╔═╡ db983b9d-872d-4155-b30c-28e493f8900b
begin
#module myCirc
	#export t,Ground,connect, OnePort,Resistor,real_transformer,Pin, ConstantVoltage, Capacitor,Inductor,CoupledInductor
   #  using ModelingToolkit, Plots, DifferentialEquations

@isdefined(t) || @parameters t
@connector function Pin(; name)
    sts = @variables v(t)=1.0 i(t)=1.0 [connect = Flow]
    ODESystem(Equation[], t, sts, []; name = name)
end

function Ground(;name)
    @named g = Pin()
    eqs = [g.v ~ 0]
    compose(ODESystem(eqs, t, [], []; name=name), g)
end

function OnePort(;name)
    @named p = Pin()
    @named n = Pin()
    sts = @variables v(t)=1.0 i(t)=1.0
    eqs = [
           v ~ p.v - n.v
           0 ~ p.i + n.i
           i ~ p.i
          ]
    compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end

function Resistor(;name, R = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters R=R
    eqs = [
           v ~ i * R
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function Capacitor(;name, C = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters C=C
    D = Differential(t)
    eqs = [
           D(v) ~ i / C
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function ConstantVoltage(;name, V = 1.0)
    @named oneport = OnePort()
    @unpack v = oneport
    ps = @parameters V=V
    eqs = [
           V ~ v
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function SinVoltage(;name, V = 1.0,freq=freq)
    f=2e5
	@named oneport = OnePort()
    @unpack v = oneport
     ps = @parameters V=V freq=freq

    eqs = [
           v ~ V*sin(2*π*f*t)
          ]
    extend(ODESystem(eqs, t, [v],ps; name=name), oneport)
end

	
	function Inductor(;name, L = 1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters L=L
    D = Differential(t)
    eqs = [
           D(i) ~ v / L
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end

	
function Transformer(;name,ratio=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	ps = @parameters ratio=ratio
	eqs = [ 
           
		    ts.i ~ -tp.i*ratio
			ts.v ~ tp.v/ratio
          ]
    compose(ODESystem(eqs, t, [], ps; name=name),tp,ts)
	end

function CoupledInductor(;name,coupling=0.1,ratio=1.0,Lp=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	Ls=(ratio*coupling)^2*Lp
	Mv=ratio*(Ls*Lp)^0.5
	D = Differential(t)
	ps =@parameters ratio=ratio coupling=coupling  Lp=Lp
	sts = @variables vp(t)  ip(t) vs(t) is(t)
	eqs = [ 
         vp ~ tp.v
		 ip ~ tp.i
		 vs ~ ts.v
		 is ~ ts.i
	     D(ip)~(Ls*tp.v-Mv*ts.v)/(Ls*Lp-Mv^2)	
		 D(is)~(Mv*tp.v-Lp*ts.v)/(Mv^2-Ls*Lp)   
	      ]
    compose(ODESystem(eqs, t, [vp,ip,vs,is], ps; name=name),tp,ts)
	end	

function CoupledInductanceV1(;name,coupling=0.1,ratio=1.0,Lp=1.0)
	tp=OnePort(name=:tp)
	ts=OnePort(name=:ts)
	Ls=(ratio*coupling)^2*Lp
	Mv=ratio*(Ls*Lp)^0.5
	D = Differential(t)
	ps =@parameters ratio=ratio coupling=coupling  Lp=Lp
	sts = @variables vp(t)  ip(t) vs(t) is(t)
	eqs = [ 
         vp ~ tp.v
		 ip ~ tp.i
		 vs ~ ts.v
		 is ~ ts.i
	     D(ip)~(Ls*tp.v-Mv*ts.v)/(Ls*Lp-Mv^2)	
		 D(is)~(Mv*tp.v-Lp*ts.v)/(Mv^2-Ls*Lp)   
	      ]
    compose(ODESystem(eqs, t, [vp,ip,vs,is], ps; name=name),tp,ts)
	end	


	function Diode(;name,st_d=0) # 0 bloqué, 1 passant i>0 
		
		#i(v)=IS[exp(vηVT)−1]
		d=OnePort(name=:d)
		@unpack v,i =d
		r_on= 10.0e-3 
		r_off=1e6
		#https://eng.libretexts.org/Bookshelves/Materials_Science/Supplemental_Modules_%28Materials_Science%29/Solar_Basics/D._P-N_Junction_Diodes/3%3A_Ideal_Diode_Equation
		Is=1e-3
		vt=300.0/11586.0  #300°K
		η=2.0
		#sts = @variables v(t) i(t) 
		#ps = @parameters st_d=st_d
		#st_d=0;
		#ps = @parameters st_d=st_d; 
		sts=@variables i(t) v(t);

		eqs=[ 
			
			v ~ r_on*(i>0.00)*i+r_off*(i<=0.00)*i+0.0  # condition OK (TTRBDF2() 10-9)
	        
			#i ~ Is*(ℯ^(d.v*η*vt)−1)
			#v ~ ifelse(i>0.04,r_on,ifelse(i<0.04,r_off,0.0))
		]	
		    
    extend(ODESystem(eqs, t, sts, []; name=name),d)
	end
end

# ╔═╡ f0274ab1-3e5e-45cb-b72a-259aa52a34d7
begin
#Modélisarion générateur CEA
	function TVS(;name,seuil=99,nb=200,vmax=137,imax=29)
	@named oneport = OnePort()
    @unpack v, i = oneport
    
    eqs = [
		   v ~  ((vmax-seuil)*nb/imax*i+seuil*nb)*(i>=0)+0.0   #(i - 99.2)*21.9/(137-99.2)*1e3
          # i ~ (137-99.2)/21.9*v +99.2
          ]
    extend(ODESystem(eqs, t, [], []; name=name), oneport)
	end	
	
	
end

# ╔═╡ dad66ac0-1d62-4118-bbd0-37120a0ebeeb
#https://doc.modelica.org/Modelica%204.0.0/Resources/helpWSM/Modelica/Modelica.Electrical.Analog.Semiconductors.ZDiode.html
function Zener(;name,ids=1e-6,nbv=0.74,vt=40,ibv=0.7,bv=5e3)
	@named z = OnePort()
	@unpack v, i = z
	ps=@parameters bv=bv nbv=nbv ids=ids vt=vt ibv=ibv
	rz(v)=ids*(exp(v/vt)-1)-ibv*(exp(-(v+bv)/(nbv*vt)))
	eval(Meta.parse("@register_symbolic rz(v)"))
	eqs=[i~rz(v)]
	extend(ODESystem(eqs, t, [], ps; name=name), z)
end

# ╔═╡ 8f476a2c-8664-4bac-82dc-22daf68d2760
function Switch0(;name,ton=5e-9,toff=15e-9,prf=1e5,ron=1e-3,roff=1e6) 
	function swf(t;ton=ton,toff=toff,ron=ron,roff=roff,prf=prf)
		local trec=  mod(t,1/prf)
		IfElse.ifelse(trec<=ton,
			roff,
			IfElse.ifelse(trec<=toff, 
				ron,
				roff))
	end	
	swft(t)=swf(t;ton=ton,toff=toff,ron=ron,roff=roff,prf=prf)
	eval(Meta.parse("@register_symbolic swft(t)"))
	@named sw = OnePort()
	@unpack v, i = sw
	ps= @parameters ton=ton toff=toff prf=prf ron=ron roff=roff
	eqs = [v ~ i * swft(t)]
	extend(ODESystem(eqs, t, [], ps; name=name), sw)
end

# ╔═╡ a10db5bc-ee89-47df-bc13-ef1f497be21e
begin
	@named cinc=Capacitor(C=1)
	@named cinc1=Capacitor(C=1)
	@named c50c=Capacitor(C=1)
	#@named cloadc=Capacitor(C=1e-9)
	@named cloadc=Capacitor(C=1e-9)
	@named c25nf=Capacitor(C=25e-6)
	
	@named swc=Switch0(ton=500.0,toff=2000e-9)
	@named swc1=Switch0(ton=2000e-9,toff=5000.0e-9)
	@named swccc=Switch0(ton=1e3,toff=1e3)
	
	@named diodc=Diode()
	@named diodc1=Diode()
	@named diod50=Diode()
	
	@named grdc=Ground()
	@named tvsp40= TVS(nb=400)
	@named tvsm40= TVS(nb=400)
	
	@named rp20=Resistor(R=1000)
	@named rm20=Resistor(R=1000)
	@named rloadc=Resistor(R=10e6)
	@named r50=Resistor(R=5e3)
	
	
	
	@named swc1=Switch0()
	
	@named tvsm40=TVS(nb=400)
	@named diod50=Diode()
	
	
	
	eqscea1=[
		connect(cinc.p,swc.p,diodc.n)
		connect(swc.n,diodc.p,rp20.p)	
		connect(cinc1.p,swc1.p,diodc1.n)	
		connect(swc1.n,diodc1.p,rm20.p)	
		connect(rp20.n,c25nf.p,rm20.n)
	    connect(c25nf.n,diod50.p,rloadc.p,cloadc.p,swccc.p)
		connect(diod50.n,r50.p)
		connect(r50.n,c50c.n)
		connect(c50c.p,grdc.g,rloadc.n,cloadc.n,swccc.n,cinc.n,cinc1.n)
		#=connect(cinc.p,swc.p,diodc.n,tvsp40.p)
		connect(swc.n,diodc.p,tvsp40.n,rp20.p)	
		connect(cinc1.p,swc1.p,diodc1.n,tvsm40.p)	
		connect(swc1.n,diodc1.p,tvsm40.n,rm20.p)	
		connect(rp20.n,c25nf.p,rm20.n)
	    connect(c25nf.n,diod50.p,rloadc.p,cloadc.p,swccc.p)
		connect(diodc.n,r50.p)
		connect(r50.n,c50c.p)
		connect(c50c.n,grdc.g,rloadc.n,cloadc.n,swccc.n,cinc.n,cinc1.n) ,cinc.n,cinc1.n)=#
		]
u0c1=[
		cinc.v=>10.0e3
		cinc1.v=>-10.0e3
		c25nf.v=>60e3
		#coutc.v=>70e3
	    c50c.v=>50.0e3
	   cloadc.v=>-50e3
	   # swc.v=>0
		#=linec.l_1.i=>0.0
		linec.l_2.i=>0.0
		linec.l_3.i=>0.0
		linec.c_1.v=>0.0
		linec.c_2.v=>0.0
		linec.c_3.v=>0.0=#
	]

  
	 @named _genecea1 = ODESystem(eqscea1, t)
  #   @named genecea1 = compose(_genecea1,[cinc,swc,diodc,tvsp40,rp20,cinc1,swc1,tvsm40,diodc1,rm20,c25nf,diod50,rloadc,cloadc,swccc,r50,c50c,grdc])
	@named genecea1 = compose(_genecea1,[cinc,swc,diodc,rp20,cinc1,swc1,diodc1,rm20,c25nf,diod50,rloadc,cloadc,swccc,r50,c50c,grdc])


	


	
     syscea1= structural_simplify(genecea1)
     tspanc1=(0,10000e-9)
     probcea1 = ODAEProblem(syscea1, u0c1, tspanc1)
     solc1 = solve(probcea1, Tsit5(),tstops=collect(0:1e-9:10000e-9))
	

	py"""
import schemdraw
import schemdraw.elements as elm
with schemdraw.Drawing(file='schematic1.png',show=False,unit=2) as d:
	d.push()
	V1 = d.add(elm.SourceV(d='up', reverse=True, label='-20 kV'))
	#d.add(elm.Line(d='up', l=2))
	V2 = d.add(elm.SourceV(d='up', reverse=False, label='+20 kV'))
	d.add(elm.Line(d='right', l=2))
	d.add(elm.Dot())
	d.push()
	d.push()
	G=d.add(elm.Switch(botlabel='switch +40 kV').right())
	#d.add(elm.Line(d='right', l=2))
	d.pop()
	d.add(elm.Line(d='up', l=1))
	d.add(elm.Diode(reverse=True).right())
	#d.add(elm.Line(d='right', l=2))
	d.pop()
	d.add(elm.Line(l=2).up())
	d.add(elm.Zener().right())
	#d.add(elm.Line(d='right', l=2))
	#d.add(elm.Zener(reverse=True).right())
	d.add(elm.Line(l=2,d='down'))
	d.add(elm.Resistor(d='right',label='1 k$\Omega$'))
	d.add(elm.Capacitor(d='right',label='25 nF'))
	d.add(elm.Diode(reverse=False).down())
	d.add(elm.Resistor(d='down',label='5 k$\Omega$'))
	V50=d.add(elm.SourceV(reverse=False,label='-50 kV').down())
	#now the load
	d.add(elm.Line(d='right'))
	d.push()
	d.add(elm.Capacitor(d='up'))
	d.add(elm.Line(l=4).up())
	d.pop()
	d.add(elm.Line(l=2).right())
	d.push()
	d.add(elm.Resistor().up())
	d.add(elm.Line(l=4).up())
	d.pop()
	d.add(elm.Line(l=2).right())
	d.add(elm.Switch(botlabel='mise en CC').up())
	d.add(elm.Line(l=4).up())
	d.add(elm.Line(l=6).left())
	d.pop()
	d.add(elm.Line(d='down', l=2))
	d.add(elm.Line(d='right', l=2))
	d.push()
	d.add(elm.Switch(botlabel='switch -40 kV').right())
	#d.add(elm.Line(d='right', l=2))
	d.pop()
	
	d.add(elm.Line(d='up', l=1))
	d.push()
	d.add(elm.Diode(reverse=False).right())
	#d.add(elm.Line(d='right', l=2))
	d.pop()
	d.add(elm.Line(l=1).up())
	#d.add(elm.Zener().right())
	d.add(elm.Zener(reverse=True).right())
	d.add(elm.Line(l=2).down())
	d.push()
	d.add(elm.Resistor(d='right',label='1 k$\Omega$'))
	d.push()
	
	d.add(elm.Line(l=6).up())
	d.pop()
	d.add(elm.Line(l=1,xy=V2.start).left())
	d.add(elm.Ground())
	d.add(elm.Line(l=1,xy=V50.end).down())
	d.add(elm.Ground())
	d.pop()
	d.add(elm.Zener().down())
	#d.add(elm.Zener(reverse=True).down())
	d.add(elm.Ground())
		"""
load("D:/2022/FIATLUX_Implementation/NotebooksPluto/schematic1.png")
end

# ╔═╡ d01e1243-91ac-4bb1-a609-b7b4ad5ead12
plot(solc1,idxs=[ cloadc.v])

# ╔═╡ cc6d5a4a-38fb-46b3-a77b-2f91cf7daed0
function SwitchET(;name,ton=5e-9,toff=15e-9,prf=1e5,ron=1e-3,roff=1e6,Vmax=5e3) 
	@named sw=Switch0(ton=ton,toff=toff,prf=prf,ron=ron,roff=roff)
	@named zn=Zener(bv=Vmax)
	@named zc=Resistor(R=100)
	@named l=Inductor(L=40e-9)
	@named c=Capacitor(C=40e-12)
	sts=@variables i(t) v(t)
	#@unpack v, i = sw
#=	r=false
	lc=true
	eqs=[]
	if r
		push!(eqs,connect(sw.p,zn.n))
		push!(eqs,	connect(zc.p,zn.p))
		push!(eqs, connect(zc.n,sw.n))
		eqs=convert(Vector{Equation},eqs)
		return compose(ODESystem(eqs,t,[],[];name=name),sw,zn,zc)
	elseif lc
	   eqs=[connect(sw.p,c.p)
	   	connect(sw.n,l.p,c.n) 
	   ]
		return compose(ODESystem(eqs,t,[],[];name=name),sw,zn,c,l)
	else
		push!(eqs,connect(sw.p,zn.n))
	    push!(eqs,connect(zn.p,sw.n))
		eqs=convert(Vector{Equation},eqs)
	   return compose(ODESystem(eqs,t,[],[];name=name),sw,zn)
=#
	eqs=vcat([connect(sw.p,c.p),connect(sw.n,l.p,c.n), i ~ sw.p.i,v ~ sw.v + l.v])
	   
		return compose(ODESystem(eqs,t,sts,[];name=name),sw,zn,c,l)
end

# ╔═╡ f5935264-e540-447b-b195-035a842de40c
function Line(;name=name,clength=1.0,nloop=3)
	@named l 1:nloop i -> Inductor(L=2.5229658792650916e-7*(clength/nloop))
    @named c 1:nloop i -> Capacitor(C=1.0104986876640419e-10*(clength/nloop)) 
    vari=vcat(l,c)
	rq_equ=[]
	for i in 1:nloop-1
		push!(rq_equ,connect(l[i].n,c[i].p,l[i+1].p))
	end
	for i in 2:nloop
		push!(rq_equ,connect(c[i].n,c[i-1].n))
	end
	push!(rq_equ,connect(l[nloop].n,c[nloop].p))	
	 rq_equ=convert(Vector{Equation},rq_equ)
    compose(ODESystem(rq_equ, t, [], []; name=name), vari)
end

# ╔═╡ 2600c1c1-9f26-4981-a31b-48b76993c431
begin
	

	
	function Switch(;name,ton=5e-9,toff=15e-9,prf=1e5,vmax=5e3,imax=1e2,tr=5e-9,tf=5e-9,ron=1e-3,roff=1e6)


	lsw=vmax*tr/imax
	csw=imax*tf/vmax
     @named cswp=Capacitor(C=csw)	
	 @named swout=Inductor(L=lsw)		
	 @named swin=Switch0()
	ps = @parameters vmax=vmax imax=imax tr=tr tf=tf lsw=lsw csw=csw ron=ron roff=roff
  
	
	eqs = [ 
          # connect(swin.p, cswp.p)
		  # connect(swin.n, cswp.n,swout.p)
			swin.p.v ~ cswp.p.v
		swin.n.v ~  cswp.n.v
		swin.n.v  ~  swout.p.v
			swin.p.i ~ cswp.p.i
		swin.n.i ~  cswp.n.i
		swin.n.i  ~  swout.p.i
          ]
    compose(ODESystem(eqs, t, [], ps; name=name),swout,cswp,swin)
	end

	
end

# ╔═╡ d2d059bb-093a-48c1-b5e4-620883901102
begin
	#=
		mymax=findmax(checkintv,0:1e-9: swonnp+swtrnp+inouttime)
	tr1(t)=checkintv(t)-mymax[1]*0.2
	tr2(t)=checkintv(t)-mymax[1]*0.8
	find_zero(tr2, (0, mymax[2]*1e-9))-find_zero(tr1, (0, mymax[2]*1e-9))
end
	=#
	coutlpf=DataInterpolations.LinearInterpolation(lpsol[coutlp.p.v],lpsol[t])
	lpmax=findmax(coutlpf,0:0.1e-9:40e-9)
	tr1lp(t)=coutlpf(t)-lpmax[1]*0.1
	tr2lp(t)=coutlpf(t)-lpmax[1]*0.9
	
	trlp=find_zero(tr2lp,(0,lpmax[2]*0.1e-9))-find_zero(tr1lp,(0,lpmax[2]*0.1e-9))
	tflp=find_zero(tr1lp,(lpmax[2]*0.1e-9,60e-9))-find_zero(tr2lp,(lpmax[2]*0.1e-9,60e-9))
	

end

# ╔═╡ adda199a-5f9f-4c4f-9d50-64fa61532403
trlp,tflp,twidthlp,Llp,Clp
#3.05118e-9 6.39389e-9 1.0e-8 5.0e-8 4.0e-11
#=
2.70902e-9
8.42626e-9
1.5e-8
5.0e-9
4.0e-11
=#

# ╔═╡ a9a0da57-2dc1-4a0b-8367-1ce3789b2b6d
tr2lp(0)

# ╔═╡ 6edd757a-b8d0-444a-a98d-f00a0a2ef31a
begin
	th50lp(t)=coutlpf(t)-lpmax[1]*0.5
	twidhlp=-(find_zero(th50lp,(0,lpmax[2]*0.1e-9))-find_zero(th50lp,(lpmax[2]*0.1e-9,60e-9)))
end


# ╔═╡ 0b92fbff-a7e4-4d1a-a09d-dd614308fb18
th50lp(20e-9)

# ╔═╡ 5b754ffc-2145-411e-9900-da0aab2fce09
coutlpf(3e-9)

# ╔═╡ 9168fd8c-f425-46db-9b8b-091d1c04bab0
coutlpf(1e-9)

# ╔═╡ d5e8d7c5-9a21-464e-9895-19f68493b964
function Switchrec(;name,ton=ton,toff=toff,ron=ron,roff=roff,prf=1e7) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton toff=toff prf=prf
		local trec=  mod(t,1/prf)
	    eqs = [
	           
			   v ~ IfElse.ifelse(trec<=ton,roff,IfElse.ifelse(trec<=toff,ron,roff))*i
	          ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
end

# ╔═╡ 199bbb2b-2402-4cb3-bd98-5150defbc8a3
begin
	function BiswitchET(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6,prf=1e5)

		@named oneport = OnePort()
	    @unpack v, i = oneport
	
		function bir_switch(t;ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,prf=prf)
				local trec=  mod(t,1/prf)
			IfElse.ifelse(trec<=ton,
				   	roff,
				   	IfElse.ifelse(trec<=ton+rt,
				   			(ron-roff)/rt*trec+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(trec<=ton+twidth, 
								ron,
								IfElse.ifelse(trec<ton+twidth+rt,
					   				(roff-ron)/rt*trec+ron-(roff-ron)/rt*(ton+twidth),
									roff
								))))
		end	
			
		#eval(Meta.parse("@register_symbolic bir_switch(t)"))
		sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt prf=prf
	bir_switch1(t)=bir_switch(t;ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,prf=prf)
		eval(Meta.parse("@register_symbolic bir_switch(t)"))
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*bir_switch1(t)
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end


		function switchilimit(;name,ton=ton,twidth=10e-9,rt=rt,ron=1e-3,roff=1e6,prf=1e5,ilimit=200)

		@named oneport = OnePort()
	    @unpack v, i = oneport
	
		
		function bir_switch(t;ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,prf=prf)
				local trec=  mod(t,1/prf)
			IfElse.ifelse(trec<=ton,
				   	roff,
				   	IfElse.ifelse(trec<=ton+rt,
				   			(ron-roff)/rt*trec+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(trec<=ton+twidth, 
								ron,
								IfElse.ifelse(trec<ton+twidth+rt,
					   				(roff-ron)/rt*trec+ron-(roff-ron)/rt*(ton+twidth),
									roff
								))))
		end	
			
		#eval(Meta.parse("@register_symbolic bir_switch(t)"))
		sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt prf=prf
	bir_switch1(t)=bir_switch(t;ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,prf=prf)
		eval(Meta.parse("@register_symbolic bir_switch(t)"))
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			  i ~ min(200,v/bir_switch1(t))
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end

	
		function switchl(;name,ton=ton,twidth=10e-9,vmax=5e3,ilimit=100,tr=5e-9,ron=1e-3,roff=1e6,prf=1e5)
		lsw=tr*vmax/ilimit

		@named oneport = OnePort()
	    @unpack v, i = oneport
	
		
		function bir_switchv1(t;ton=ton,twidth=twidth,ron=ron,roff=roff,prf=prf)
				local trec=  mod(t,1/prf)
			IfElse.ifelse(trec<=ton,
				   		roff,
				    IfElse.ifelse(trec<=ton+twidth, 
						ron,
					    roff
					))
		end	
			
		#eval(Meta.parse("@register_symbolic bir_switch(t)"))
		sts= []#@variables t rsw
		
		ps= @parameters ton=ton twidth=twidth prf=prf  ron=ron roff=roff 
	bir_switchv2(t)= bir_switchv1(t;ton=ton,twidth=twidth,ron=ron,roff=roff,prf=prf)
		eval(Meta.parse("@register_symbolic bir_switchv2(t)"))
		 D = Differential(t)
    
        
			#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	       eqs = [
          # D(i) ~ v/lsw - bir_switchv2(t)/lsw*i
			i ~ v/ bir_switchv2(t)
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end

end

# ╔═╡ 976f8973-f4d6-447c-9d6f-c2980d8409fe
begin
	npsol
checkintv=DataInterpolations.LinearInterpolation(checksol[checkvar.v],checksol[t])
	#CubicSpline(checksol[checkvar.v],checksol[t])
checkinti=DataInterpolations.LinearInterpolation(checksol[checkvar.i],checksol[t])
#CubicSpline(checksol[checkvar.i],checksol[t])
end

# ╔═╡ 35ea2c79-1aaa-4ea1-a259-31211dd63aea
begin
	mymax=findmax(checkintv,0:1e-9: swonnp+swtrnp+inouttime)
	tr1(t)=checkintv(t)-mymax[1]*0.2
	tr2(t)=checkintv(t)-mymax[1]*0.8
	find_zero(tr2, (0, mymax[2]*1e-9))-find_zero(tr1, (0, mymax[2]*1e-9))
end

# ╔═╡ b8d47a90-62dd-4ffd-890b-f756c68a1dab
mymax[1]

# ╔═╡ 067c53c1-be9f-4f32-a584-e8d8e6d8f589
checkintr(t)=checkintv(t)/checkinti(t)

# ╔═╡ 27af5a6b-9126-49aa-b2ac-9c4c5cb9b933
checkpower(t)=checkinti(t)*checkintv(t)

# ╔═╡ a06350b1-013d-46da-ab1c-e6c7545ce81b
"vmax="*string(maximum(checkintv))*",imax="*string(maximum(checkinti))*",imean="*string(mean(checkinti))*",irms="*string(mean(abs2,checkinti))

# ╔═╡ 599c5c67-9baf-484a-b4a6-0d99ece40643
quadgk(checkpower, 0, min(checksol[t][end],1/prfnp), rtol=1e-5)[1]*prfnp

# ╔═╡ c1fca69b-bf9e-4341-bb72-37012bd2703b
begin
#switch ideal
	function SwitchET1(;name,R=1e3,Cp=1e-11)
		@parameters R=R Cp=cp
		@named oneport = OnePort()
	    @unpack v, i = oneport
        sts=[]
		ps=[]
		eqs = [    
			   v ~ i*R
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
	end
	
	#swet=SwitchET1(name=:swet)
	
end

# ╔═╡ 0102cab9-ffa9-49e9-b56a-e2d1fea2389c
begin
	function Vpulse(t,f,d,v0,tr)
		t2=1.0/f
		tm=t%t2
		ifelse(tm<=tr,v0*tm/tr,
			ifelse(tm<=d-tr,v0,
				ifelse(tm<=d,v0-v0*(tm+tr-d)/tr , 0.0)
					
								))
					
	end
	
	function Vpulsevoltage(;name,d=d,f=f)
    @named oneport = OnePort()
    @unpack v = oneport
    ps =[] # @parameters V=V
    eqs = [
           v ~ vup(t,d,f)
          ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end
	vup(t,d,f)= Vpulse(t,f,d,5e3,5e-9)
end

# ╔═╡ a2a565c5-1a4f-43a5-9193-0e1cf373e18a
begin
	vup1(t)=vup(t,1e-8,1e7)
	plot(0:1e-9:200e-9,vup1,tstops=[1.0/1.0e7])
end

# ╔═╡ b900cf2f-88ee-4462-a1fd-0b65e553e28b
1.0104986876640419e-10*clength/nloop

# ╔═╡ 9a0f1299-9517-4d6b-9a42-c948e32509e0
typeof(linenp)

# ╔═╡ cda90c96-f253-46f3-90fb-1acbcb9570ce
1begin
	li=nothing
	ci=nothing
	cout=nothing
	rc_eqs2=[]
	clength=linelength
	nloop=nloopini #0

	name="myname"
	# réalisation d'unne ligne de transmission
	function line(;name=name)
		
		local vari=""
		for i in 1:nloop-1
			vari*="li["*string(i)*"],ci["*string(i)*"],"
		end
		vari*="li[nloop],"
		vari*="cout"

        if connexion=="coax"
			eval(Meta.parse("@named cout=Capacitor(C=1.0104986876640419e-10*"*string(clength/nloop)*")"))
		else
			eval(Meta.parse("@named cout=Capacitor(C=40e-12)"))
		end
		eval(Meta.parse("@named li 1:"*string(nloop)*" i -> Inductor(L=2.5229658792650916e-7*"*string(clength/nloop)*")"))
		eval(Meta.parse("@named ci 1:"*string(nloop-1)*" i -> Capacitor(C=1.0104986876640419e-10*"*string(clength/nloop)*")"))
		
		try
			for i in 1:nloop-1
				push!(rc_eqs2,connect(li[i].n,ci[i].p,li[i+1].p))
				#push!(rc_eqs2,connect(li[i].n,ci[i+1].p))
			end
		catch
		end

		for i in 2:nloop-1
			push!(rc_eqs2,connect(ci[i].n,ci[i-1].n))
		end
	#	push!(rc_eqs2,connect(li[nloop].p,ci[nloop].p))
		push!(rc_eqs2,connect(li[nloop].n,cout.p))
		push!(rc_eqs2,connect(cout.n,ci[nloop-1].n))
	 #


		

	 eval(Meta.parse(name*"=compose(ODESystem(rc_eqs2,t,name=:"*name*"),"*vari*")"))



		
	end
	#=
		function line0(;name="myname")
		
		local vari=""
		for i in 1:nloop
			vari*="li["*string(i)*"],ci["*string(i)*"],"
		end
		vari*="cout"


		eval(Meta.parse("@named cout=Capacitor(C=40e-12)"))
		eval(Meta.parse("@named li 1:"*string(nloop)*" i -> Inductor(L=2.5229658792650916e-7*"*string(clength/nloop)*")"))
		eval(Meta.parse("@named ci 1:"*string(nloop)*" i -> Capacitor(C=1.0104986876640419e-10*"*string(clength/nloop)*")"))
		
		try
			for i in 1:nloop-1
				push!(rc_eqs2,connect(ci[i].p,li[i].p))
				push!(rc_eqs2,connect(li[i].n,ci[i+1].p))
			end
		catch
		end

		for i in 2:nloop
			push!(rc_eqs2,connect(ci[i].n,ci[i-1].n))
		end
		push!(rc_eqs2,connect(li[nloop].p,ci[nloop].p))
		push!(rc_eqs2,connect(li[nloop].n,cout.p))
		push!(rc_eqs2,connect(cout.n,ci[nloop].n))
	  eval(Meta.parse(name*"=compose(ODESystem(rc_eqs2,t,name=:"*name*"),"*vari*")"))
	end
	=#
	@named myline=line(name="myline")
	
	#line()
	
	
	#nothing
end

# ╔═╡ 03fe318c-94c8-4026-b9d2-5235cefafd1e
li

# ╔═╡ bbd7d4d4-d6ab-422c-8609-f9cb2fd2af97
1begin
    duration=40e-9
	R = 1.0
	C = 40.0e-12
	
	#Cload=1.0e-12
	V = 5e3
	ratio=1.0
	@register_symbolic vup(t,d,f)
	#@named transformer = Transformer(ratio=ratio)
	@named resistor = Resistor(R = R)
	#@named cload = Capacitor(C=C)
	#@named source = ConstantVoltage(V = V)
	@named source = Vpulsevoltage(d=10e-9,f=1e5)

	@named ground1 = Ground()
	
		rc_eqs = [ connect(source.p, resistor.p)
			   connect(resistor.n, myline.li_1.p)
		       connect(myline.ci_1.n, ground1.g,source.n)]
	
		@named rc_model = ODESystem(rc_eqs, t)
		rc_model = compose(rc_model, [resistor, myline, source, ground1])
	
	    sys = structural_simplify(rc_model)

	
		u0=[ ]
     
		for i in 1:nloop-1	
			mystr="myline.ci_"*string(i)*".v"
			mypair=eval(Meta.parse(mystr*"=>0.0"))
			push!(u0,mypair)
		end
		push!(u0,myline.cout.v=>0.0)
        u0=convert(Vector{Pair{Num, Float64}},u0)
		prob = ODAEProblem(sys, u0, (0, duration))
		sol = solve(prob, Tsit5())

	#plot(sol, vars=[myline.ci_1.v,eval(Meta.parse("myline.ci_"*string(nloop-1)*".v"))])
	plot(sol, idxs=[myline.cout.v])
		
end

# ╔═╡ 5b707670-7ecb-4458-b16d-a818b0930c2b
#https://discourse.julialang.org/t/modeling-a-crowbar-circuit-with-modelingtoolkit-jl/81968/5
begin
	function VoltageSensor(; name)
	    @named p = Pin()
	    @named n = Pin()
	    @variables v(t)=1.0
	    eqs = [
	        p.i ~ 0
	        n.i ~ 0
	        v ~ p.v - n.v
	    ]
	 ODESystem(eqs, t, [v], []; systems=[p, n], name=name)
	end
	#@named level = VoltageSensor()

end

# ╔═╡ be0e5e49-3143-4a4d-a519-15b8acdd30c3
@connector 

# ╔═╡ 4a6f61b7-c30d-4174-803e-3df380747982
1begin
	function Switch(;name,ton=ton,toff=toff) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
		ps= @parameters ton=ton toff=toff rsw
		
	    eqs = [
	           v ~ i * rsw
			   
	          ]
	    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
	end

		function Switch1(;name,ton=ton,toff=toff,ron=ron,roff=roff) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton toff=toff 
		
	    eqs = [
	           
			   v ~ IfElse.ifelse(t<=ton,roff,IfElse.ifelse(t<=toff,ron,roff))*i
	          ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
	end

		function Switchrt(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6) 
		@named oneport = OnePort()
	    @unpack v, i = oneport
	   sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt ron=ron roff=roff
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*(IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+rt,
				   			(ron-roff)/rt*t+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+rt,
					   				(roff-ron)/rt*t+ron-(roff-ron)/rt*(ton+twidth),
									roff
								)))))]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end


	   
	
		function SwitchET(;name,ton=ton,twidth=twidth,rt=rt,ron=1e-3,roff=1e6,rdiode=1e-3)

		@named oneport = OnePort()
	    @unpack v, i = oneport


			
		function r_switch(t;i=i,ton=ton,twidth=twidth,rt=rt,ron=ron,roff=roff,rdiode=rdiode)
			IfElse.ifelse(i<0.0,rdiode,
				   IfElse.ifelse(t<=ton,
				   	roff,
				   	IfElse.ifelse(t<=ton+rt,
				   			(ron-roff)/rt*t+roff-(ron-roff)/rt*ton,
				   			IfElse.ifelse(t<=ton+twidth, 
								ron,
								IfElse.ifelse(t<ton+twidth+rt,
					   				(roff-ron)/rt*t+ron-(roff-ron)/rt*(ton+twidth),
									roff
								)))))
		end	
			
		eval(Meta.parse("@register_symbolic r_switch(t,i)"))
		sts= []#@variables t rsw
		ps= @parameters ton=ton twidth=twidth rt=rt rdiode=rdiode
		#a=(roff-ron)/tr  b=ron-a*(ton+twidth)
	    eqs = [    
			   v ~ i*r_switch(t)
				   ]
	    extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
		end
end

# ╔═╡ 70acb7f4-510a-43dc-b389-84641e84b3c1


# ╔═╡ baef13c4-dc58-49df-b877-6d15d60212a5
begin
	#import Pkg; 
	#Pkg.add(url="https://github.com/hyrodium/BasicBSplineExporter.jl")
	#Pkg.add("BasicBSpline")
	#Pkg.add("StaticArrays")
	#Pkg.add("Plots")	
	#Pkg.add("ModelingToolkit"@v8.23.0)
	#Pkg.add("QuadGK")
	#Pkg.add("IfElse")
	#Pkg.add("Sobol")
	#Pkg.add("DataInterpolations")
	#Pkg.add("DifferentialEquations")
	#Pkg.add("PyPlot")
	#Pkg.add("Interpolations")
	#Pkg.status("ModelingToolkit")
	#Pkg.add("PlutoUI")
	#Pkg.add("Statistics")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BasicBSpline = "4c5d9882-2acf-4ea4-9e48-968fd4518195"
DataInterpolations = "82cc6244-b520-54b8-b5a6-8a565e85f1d0"
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
IfElse = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
Interpolations = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
Sobol = "ed01d8cd-4d21-5b2a-85b4-cc3bdc58bad4"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
BasicBSpline = "~0.8.2"
DataInterpolations = "~3.10.1"
DifferentialEquations = "~7.5.0"
FileIO = "~1.16.0"
IfElse = "~0.1.1"
Images = "~0.25.2"
Interpolations = "~0.14.6"
ModelingToolkit = "~8.29.1"
Plots = "~1.35.5"
PlutoUI = "~0.7.48"
PyCall = "~1.94.1"
QuadGK = "~2.5.0"
Roots = "~2.0.8"
Sobol = "~1.5.0"
StaticArrays = "~1.5.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractAlgebra]]
deps = ["GroupsCore", "InteractiveUtils", "LinearAlgebra", "MacroTools", "Markdown", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "da90f455c3321f244efd72ef11a8501408a04c1a"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.27.6"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "52b3b436f8f73133d7bc3a6c71ee7ed6ab2ab754"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.3"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["ArrayInterfaceCore", "Compat", "IfElse", "LinearAlgebra", "Static"]
git-tree-sha1 = "d6173480145eb632d6571c148d94b9d3d773820e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "6.0.23"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e6cba4aadba7e8a7574ab2ba2fcfb307b4c4b02a"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.23"

[[deps.ArrayInterfaceGPUArrays]]
deps = ["Adapt", "ArrayInterfaceCore", "GPUArraysCore", "LinearAlgebra"]
git-tree-sha1 = "fc114f550b93d4c79632c2ada2924635aabfa5ed"
uuid = "6ba088a2-8465-4c0a-af30-387133b534db"
version = "0.2.2"

[[deps.ArrayInterfaceOffsetArrays]]
deps = ["ArrayInterface", "OffsetArrays", "Static"]
git-tree-sha1 = "c49f6bad95a30defff7c637731f00934c7289c50"
uuid = "015c0d05-e682-4f19-8f0a-679ce4c54826"
version = "0.1.6"

[[deps.ArrayInterfaceStaticArrays]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceStaticArraysCore", "LinearAlgebra", "Static", "StaticArrays"]
git-tree-sha1 = "efb000a9f643f018d5154e56814e338b5746c560"
uuid = "b0d46f97-bff5-4637-a19a-dd75974142cd"
version = "0.1.4"

[[deps.ArrayInterfaceStaticArraysCore]]
deps = ["Adapt", "ArrayInterfaceCore", "LinearAlgebra", "StaticArraysCore"]
git-tree-sha1 = "93c8ba53d8d26e124a5a8d4ec914c3a16e6a0970"
uuid = "dd5226c6-a4d4-4bc7-8575-46859f9c95b9"
version = "0.1.3"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9a8017694c92ca097b23b3b43806be560af4c2ce"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.8.12"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "d37d493a1fc680257f424e656da06f4704c4444b"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.7"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "Future", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables", "ZygoteRules"]
git-tree-sha1 = "7fe6d92c4f281cf4ca6f2fba0ce7b299742da7ca"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.37"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BasicBSpline]]
deps = ["ChainRulesCore", "FastGaussQuadrature", "IntervalSets", "LinearAlgebra", "RecipesBase", "StaticArrays"]
git-tree-sha1 = "bf3a5e88f38e43a99129d48fe9c5cb6c56f75a4a"
uuid = "4c5d9882-2acf-4ea4-9e48-968fd4518195"
version = "0.8.2"

[[deps.Bijections]]
git-tree-sha1 = "fe4f8c5ee7f76f2198d5c2a06d3961c249cce7bd"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.4"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "eaee37f76339077f86679787a71990c4e465477f"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.4"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase", "SparseArrays"]
git-tree-sha1 = "2f80b70bd3ddd9aa3ec2d77604c1121bd115650e"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.9.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "Static"]
git-tree-sha1 = "9bdd5aceea9fa109073ace6b430a24839d79315e"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.27"

[[deps.CSTParser]]
deps = ["Tokenize"]
git-tree-sha1 = "3ddd48d200eb8ddf9cb3e0189fc059fd49b97c1f"
uuid = "00ebfdb7-1f24-5e51-bd34-a7502290713f"
version = "3.3.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "5522c338564580adf5d58d91e43a55db0fa5fb39"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.10"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "64df3da1d2a26f4de23871cd1b6482bb68092bd5"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.3"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "4cd7063c9bdebdbd55ede1af70f3c2f48fab4215"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.6"

[[deps.CommonSolve]]
git-tree-sha1 = "332a332c97c7071600984b3c31d9067e1a4e6e25"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[deps.CompositionsBase]]
git-tree-sha1 = "455419f7e328a1a2493cabc6428d79e951349769"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.1"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[deps.DataInterpolations]]
deps = ["ChainRulesCore", "LinearAlgebra", "Optim", "RecipesBase", "RecursiveArrayTools", "Reexport", "RegularizationTools", "Symbolics"]
git-tree-sha1 = "cd5e1d85ca89521b7df86eb343bb129799d92b15"
uuid = "82cc6244-b520-54b8-b5a6-8a565e85f1d0"
version = "3.10.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "UnPack"]
git-tree-sha1 = "02685529c5b22478e50c981d679f12d5e03808c6"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.38.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterfaceCore", "ChainRulesCore", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "Static", "StaticArrays", "Statistics", "Tricks", "ZygoteRules"]
git-tree-sha1 = "1691af09e21555641fe762b28bda3dd927256765"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.105.2"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "16cecaff5228c6cb22cda8e81aa96442395cdfc5"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.24.2"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "d0762f43a0c75a0b168547f7e4cc47abf6ea6a30"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.13.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "8b7a4d23e22f5d44883671da70865ca98f2ebf9d"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.12.0"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "f6b75cc940e8791b5cef04d29eb88731955e759c"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.5.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "04db820ebcfc1e053bd8cbb8d8bccf0ff3ead3f7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.76"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "85cf537e38b7f34a84eaac22b534aa1b5bf01949"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.14"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "d0fa82f39c2a5cdb3ee385ad52bc05c42cb4b9f0"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.4.5"

[[deps.EnumX]]
git-tree-sha1 = "e5333cd1e1c713ee21d07b6ed8b0d8853fabe650"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.3"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExponentialUtilities]]
deps = ["ArrayInterfaceCore", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "b19c3f5001b11b71d0f970f354677d604f3a1a97"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.19.0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "LinearAlgebra", "Polyester", "Static", "StrideArraysCore"]
git-tree-sha1 = "21cdeff41e5a1822c2acd7fc7934c5f450588e00"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.1"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "58d83dd5a78a36205bdfddb82b1bb67682e64487"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "0.4.9"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "14a6f7a21125f715d935fe8f83560ee833f7d79d"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "1.2.7"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "802bfc139833d2ba893dd9e62ba1767c88d708ae"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.5"

[[deps.FiniteDiff]]
deps = ["ArrayInterfaceCore", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "5a2cff9b6b77b33b89f3d97a4d367747adce647e"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.15.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "187198a4ed8ccd7b5d99c41b69c679269ea2b2d4"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.32"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "a5e6e7f12607e90d71b09e6ce2c965e41b337968"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.1"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "6872f5ec8fd1a38880f027a26739d42dcda6691f"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.2"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78e2c69783c9753a91cdae88a8d432be85a2ab5e"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Glob]]
git-tree-sha1 = "4df9f7e06108728ebf00a0a11edee4b29a482bb2"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ba2d094a88b6b287bd25cfa86f301e7693ffae2f"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.4"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Groebner]]
deps = ["AbstractAlgebra", "Combinatorics", "Logging", "MultivariatePolynomials", "Primes", "Random"]
git-tree-sha1 = "144cd8158cce5b36614b9c95b8afab6911bd469b"
uuid = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
version = "0.2.10"

[[deps.GroupsCore]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9e1a5e9f3b81ad6a5c613d181664a0efc6fe6dd7"
uuid = "d5909c97-4eac-4ecc-a3dc-fdd0858a4120"
version = "0.4.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "a97d47758e933cd5fe5ea181d178936a9fc60427"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "b7b88a4716ac33fe31d6556c02fc60017594343c"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.8"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "b1798a4a6b9aafb530f8f0c4a7b2eb5501e2f2a3"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.16"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "8b251ec0582187eff1ee5c0220501ef30a59d2f7"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.2"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "124626988534986113cfd876e3093e4a03890f58"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "Statistics"]
git-tree-sha1 = "0c703732335a75e683aec7fdfc6d5d1ebd7c596f"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.3"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "03d1301b7ec885b266c0f816f338368c6c0b81bd"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.2"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "f366daebdfb079fd1fe4e3d560f99a0c892e15bc"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.0"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "842dd89a6cb75e02e85fdd75c760cdc43f5d6863"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.6"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "3f91cd3f56ea48d4d2a75c2a65455c5fc74fa347"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.3"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "1c3ff7416cb727ebf4bab0491a56a296d7b8cf1d"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.25"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.JuliaFormatter]]
deps = ["CSTParser", "CommonMark", "DataStructures", "Glob", "Pkg", "Tokenize"]
git-tree-sha1 = "f19e1ae54789255398020f713ec06950548c277f"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "1.0.13"

[[deps.JumpProcesses]]
deps = ["ArrayInterfaceCore", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "fd20086b905f8eef82ee4d12de7af30c3aa401bb"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.2.1"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "764164ed65c30738750965d55652db9c94c59bfe"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.4.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "92256444f81fb094ff5aa742ed10835a621aef75"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.8.4"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "49b0c1dd5c292870577b8f58c51072bd558febb9"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LabelledArrays]]
deps = ["ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "ArrayInterfaceStaticArraysCore", "ChainRulesCore", "ForwardDiff", "LinearAlgebra", "MacroTools", "PreallocationTools", "RecursiveArrayTools", "StaticArrays"]
git-tree-sha1 = "09f2b5dc592497df821681838d65460b51caad9a"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.12.4"

[[deps.LambertW]]
git-tree-sha1 = "2d9f4009c486ef676646bca06419ac02061c088e"
uuid = "984bce1d-4616-540c-a9ee-88d1112d94c9"
version = "0.4.5"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "73e2e40eb02d6ccd191a8a9f8cee20db8d5df010"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.11"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LeastSquaresOptim]]
deps = ["FiniteDiff", "ForwardDiff", "LinearAlgebra", "Optim", "Printf", "SparseArrays", "Statistics", "SuiteSparse"]
git-tree-sha1 = "06ea4a7c438f434dc0dc8d03c72e61ee0bf3629d"
uuid = "0fc2ff8b-aaa3-5acd-a817-1944a5e08891"
version = "0.8.3"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterfaceCore", "DocStringExtensions", "FastLapackInterface", "GPUArraysCore", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "SnoopPrecompile", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "9dc30911bb8697a489c298339536d5234d54ba96"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.27.1"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceOffsetArrays", "ArrayInterfaceStaticArrays", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SIMDTypes", "SLEEFPirates", "SnoopPrecompile", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "9f6030ca92d1a816e931abb657219c9fc4991a96"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.136"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MLStyle]]
git-tree-sha1 = "0638598b2ea9c60303e036be920df8df60fe2812"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.14"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

[[deps.Metatheory]]
deps = ["AutoHashEquals", "DataStructures", "Dates", "DocStringExtensions", "Parameters", "Reexport", "TermInterface", "ThreadsX", "TimerOutputs"]
git-tree-sha1 = "0f39bc7f71abdff12ead4fc4a7d998fb2f3c171f"
uuid = "e9d8d322-4543-424a-9be4-0cc815abe26c"
version = "1.3.5"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "4d5917a26ca33c66c8e5ca3247bd163624d35493"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.3"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.ModelingToolkit]]
deps = ["AbstractTrees", "ArrayInterfaceCore", "Combinatorics", "ConstructionBase", "DataStructures", "DiffEqBase", "DiffEqCallbacks", "DiffRules", "Distributed", "Distributions", "DocStringExtensions", "DomainSets", "ForwardDiff", "FunctionWrappersWrappers", "Graphs", "IfElse", "InteractiveUtils", "JuliaFormatter", "JumpProcesses", "LabelledArrays", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "NaNMath", "NonlinearSolve", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "Serialization", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "Symbolics", "UnPack", "Unitful"]
git-tree-sha1 = "816536b98154a61b7d9c3cfea6a52d80a982fd34"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "8.29.1"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "393fc4d82a73c6fe0e2963dd7c882b09257be537"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.4.6"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "1d57a7dc42d563ad6b5e95d7a8aebd550e5162c0"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.5"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "440165bf08bc500b8fe4a7be2dc83271a00c0716"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.12"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.NonlinearSolve]]
deps = ["ArrayInterfaceCore", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "a754a21521c0ab48d37f44bbac1eefd1387bdcfc"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.22"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "f71d8950b724e9ff6110fc948dff5a329f901d64"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "3c3c4a401d267b04942545b1e964a20279587fd7"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "b9fe76d1a39807fdcf790b991981a922de0c3050"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.3"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "ArrayInterfaceCore", "ArrayInterfaceGPUArrays", "ArrayInterfaceStaticArrays", "ArrayInterfaceStaticArraysCore", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SnoopPrecompile", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "88b3bc390fe76e559bef97b6abe55e8d3a440a56"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.29.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "f809158b27eba0c18c269cf2a2be6ed751d3e81d"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.17"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "6c01a9b494f6d2a9fc180a08b182fcb06f0958a0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "0a56829d264eb1bc910cf7c39ac008b5bcb5a0d9"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "9ac1bb7c15c39620685a3a7babc0651f5c64c35b"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.1"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "cb2ede4b9cc432c1cba4d4452a62ae1d2a4141bb"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.16"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "b42fb2292fbbaed36f25d33a15c8cc0b4f287fcf"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.10"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ForwardDiff"]
git-tree-sha1 = "3953d18698157e1d27a51678c89c88d53e071a42"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "311a2aa90a64076ea0fac2ad7492e914e6feeb81"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "53b8b07b721b77144a0fbbbc2675222ebf40a02d"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.94.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "3c009334f45dfd546a16a57960a821a1a023d241"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.5.0"

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "4ab19353944c46d65a10a75289d426ef57b0a40c"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "7a1a306b72cfa60634f03a911405f4e64d1b718b"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.0"

[[deps.RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "062986376ce6d394b23d5d90f01d81426113a3c9"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.3"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "9b1c0c8e9188950e66fc28f40bfe0f8aac311fe0"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.7"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArraysCore", "ChainRulesCore", "DocStringExtensions", "FillArrays", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "Tables", "ZygoteRules"]
git-tree-sha1 = "3004608dc42101a944e44c1c68b599fa7c669080"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.32.0"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "0a2dfb3358fcde3676beb75405e782faa8c9aded"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RegularizationTools]]
deps = ["Calculus", "Lazy", "LeastSquaresOptim", "LinearAlgebra", "MLStyle", "Memoize", "Optim", "Random", "Underscores"]
git-tree-sha1 = "d445316cca15281a4b36b63c520123baa256a545"
uuid = "29dad682-9a27-4bc3-9c72-016788665182"
version = "0.6.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "a3db467ce768343235032a1ca0830fc64158dadf"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.8"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "3d52be96f2ff8a4591a9e2440036d4339ac9a2f7"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.2"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "dd4195d308df24f33fb10dde7c22103ba88887fa"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.1"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "938c9ecffb28338a6b8b970bda0f3806a65e7906"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.36"

[[deps.SciMLBase]]
deps = ["ArrayInterfaceCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "Preferences", "RecipesBase", "RecursiveArrayTools", "RuntimeGeneratedFunctions", "StaticArraysCore", "Statistics", "Tables"]
git-tree-sha1 = "bb721d406b9002ccd5636f576041f077b6d06371"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.64.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sobol]]
deps = ["DelimitedFiles", "Random"]
git-tree-sha1 = "5a74ac22a9daef23705f010f72c81d6925b19df8"
uuid = "ed01d8cd-4d21-5b2a-85b4-cc3bdc58bad4"
version = "1.5.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterfaceCore", "ArrayInterfaceStaticArrays", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "a434a4a3a5757440cb3b6500eb9690ff5a516cf6"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.27.0"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "de4f0a4f049a4c87e4948c04acff37baf1be01a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.7.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "f86b3a049e5d05227b10e15dbb315c5b90f14988"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.9"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "f4492f790434f405139eb3a291fdbb45997857c6"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.9.0"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "8062351f645bb23725c494be74619ef802a2ffa8"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.54.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "ac730bd978bf35f9fe45daa0bd1f51e493e97eb4"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.3.15"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SnoopPrecompile", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "fc2fb8af952ffd007dfda02c08eaf9abb6081652"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.10.3"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "Metatheory", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "027b43d312f6d52187bb16c2d4f0588ddb8c4bb2"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.19.11"

[[deps.Symbolics]]
deps = ["ArrayInterfaceCore", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "Groebner", "IfElse", "LaTeXStrings", "LambertW", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "Markdown", "Metatheory", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TermInterface", "TreeViews"]
git-tree-sha1 = "718328e81b547ef86ebf56fbc8716e6caea17b00"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "4.13.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "f8629df51cab659d70d2e5618a430b4d3f37f2c3"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.0"

[[deps.ThreadsX]]
deps = ["ArgCheck", "BangBang", "ConstructionBase", "InitialValues", "MicroCollections", "Referenceables", "Setfield", "SplittablesBase", "Transducers"]
git-tree-sha1 = "34e6bcf36b9ed5d56489600cf9f3c16843fa2aa2"
uuid = "ac1d9e8a-700a-412c-b207-f0111f4b6c0d"
version = "0.1.11"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "70e6d2da9210371c927176cb7a56d41ef1260db7"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.1"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "9dfcb767e17b0849d6aaf85997c98a5aea292513"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.21"

[[deps.Tokenize]]
git-tree-sha1 = "2b3af135d85d7e70b863540160208fa612e736b9"
uuid = "0796e94c-ce3b-5d07-9a54-7f471281c624"
version = "0.5.24"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "77fea79baa5b22aeda896a8d9c6445a74500a2c2"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.74"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "Static", "VectorizationBase"]
git-tree-sha1 = "fdddcf6b2c7751cd97de69c18157aacc18fbc660"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.14"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Underscores]]
git-tree-sha1 = "6e6de5a5e7116dcff8effc99f6f55230c61f6862"
uuid = "d9a01c3f-67ce-4d8c-9b55-35f6e4050bb1"
version = "3.0.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d57a4ed70b6f9ff1da6719f5f2713706d57e0d66"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.12.0"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "ba9d398034a2ba78059391492730889c6e45cf15"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.54"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═90d62c35-1a45-4d66-8f53-1c5ab8278c35
# ╠═52524ce7-9b8f-44c9-beb0-684610d62596
# ╠═f0274ab1-3e5e-45cb-b72a-259aa52a34d7
# ╠═d01e1243-91ac-4bb1-a609-b7b4ad5ead12
# ╠═a10db5bc-ee89-47df-bc13-ef1f497be21e
# ╠═f6437078-4ac7-49b4-9ae2-f9bb2b70c9ed
# ╠═fa8c9d92-3fee-41ac-a9f5-c217b56db62b
# ╠═a5582ae8-84d1-476d-a54b-d3401d55bd21
# ╠═0ef3a551-7cb9-4902-ba7e-f295d0624056
# ╠═fcc53f24-fac1-4608-a652-e2f839633981
# ╠═23a4002a-0275-4ea8-aee1-ebeb02d73b0b
# ╠═0256ecd1-2578-446a-bae5-81e7b7505a1f
# ╠═b8f00012-3e19-44e4-a931-297515180096
# ╠═42cf12c4-6b78-40a6-a82d-a08b4d2453a4
# ╠═f4a47652-7228-4314-bd75-4ba48a433583
# ╠═51a88907-2ff2-41c7-a87f-53b335e614e9
# ╠═fc744923-b5a0-440d-a82f-273e455d9763
# ╠═f55b1cdd-c9e8-43af-b4f7-a5491dbe5f3a
# ╠═133ae137-789a-459d-8288-9b41f725077a
# ╠═0e0e94f8-23d1-4380-8c3a-d6b61b58c629
# ╠═01d6cad1-6ae7-4b83-b588-3454ef04ed07
# ╠═e0c21f96-4a21-4b34-a681-74b4ab0f8267
# ╠═0e73fa0c-7373-451e-88aa-b92542741f5a
# ╠═aaf43df2-25e5-4117-a454-84b43613d70f
# ╠═01ef2187-85b6-4cf6-97ed-756faeb06732
# ╠═41851e9a-e072-49c8-87f1-736573e44027
# ╠═ffaba1f2-2de4-4eab-8317-02129643436a
# ╠═dad66ac0-1d62-4118-bbd0-37120a0ebeeb
# ╠═cc6d5a4a-38fb-46b3-a77b-2f91cf7daed0
# ╠═99a48120-9d55-4a6a-b106-87ffd20b4b7a
# ╠═94883e3f-eef1-4ce0-94e3-eb7db119444f
# ╠═d0106796-0845-4cfc-be01-3caeff9a78b0
# ╠═d2cf41ab-4df8-4c6e-8c25-9403cbd610ce
# ╠═6b8e138f-b744-420c-8f95-8760cff55531
# ╠═8cfe53e5-e048-4fab-bc7e-99f66529374c
# ╠═8f476a2c-8664-4bac-82dc-22daf68d2760
# ╠═150b5531-4b61-4162-9889-577e74494a34
# ╠═cde0d9ab-66c0-48d6-aa3e-90451479aa53
# ╠═f5935264-e540-447b-b195-035a842de40c
# ╠═9069d415-d9c3-43d1-91bc-9b19f2bf4778
# ╠═9cc65cde-10e5-4693-9d91-127d741dee60
# ╠═fbde6c7a-7c97-4cfa-b242-c5f413d20ccb
# ╠═6396647a-10c9-4635-9fcb-a8bf0032b2ae
# ╠═a69d27dd-3854-45c0-baf9-808c5966f028
# ╠═8e853c52-6052-4e04-9174-f8910b3535e4
# ╠═eb6e2fb7-4ebf-4fd1-b7bd-c9755ef8dc25
# ╠═e654db9f-1b14-43a1-b33b-d3c05427bd15
# ╠═1b3a2d5a-2871-4952-b1ef-ce21e02f7e16
# ╠═27b3d354-17f8-45fb-bc40-98e92e13175d
# ╠═6da39121-212d-4da7-b553-d2ac0ac3cbdd
# ╠═982b9ac0-decc-440e-9bb2-bd339e050205
# ╠═7b1038bf-f9f2-4bc3-b2c8-2e6d6eeea5d6
# ╠═9189815a-b0df-4ec8-ad88-7243a90af633
# ╠═ca0a1d99-d7d1-43be-a848-e1e0cb5523f1
# ╠═6a6213da-ba58-4cc6-be66-70115373dcf4
# ╠═ae16a06c-758f-46f7-9747-9f9a0d456765
# ╠═2ea396d1-521f-498e-afeb-4e57d3874cfe
# ╠═d72dbf23-16fb-4d47-a575-4ea0302d79ac
# ╠═06969a97-ef8d-4b1b-9a12-029c258a09d8
# ╠═25896eac-e7a0-4f15-ac8e-748714882e95
# ╠═81428a64-3a4e-49fe-a82f-cd268fb0b57e
# ╠═73170584-e179-4b59-84a1-103361b66da0
# ╠═ae13b006-a982-4848-8846-69236a933829
# ╠═2600c1c1-9f26-4981-a31b-48b76993c431
# ╠═09d4f87a-4e71-4257-92d5-f0a124acf5d6
# ╠═feeeb754-fe3f-4766-aa8f-1a7f488a0929
# ╠═5a36c4c1-f33c-49fa-a362-df995c8752f5
# ╠═26353eee-7824-4e81-ad23-41ddf666f9f9
# ╠═a3ac0de9-0b2f-4652-90f8-a22a9093a991
# ╠═aa5070f3-013a-4c4f-a838-9a480c5b63e5
# ╠═2b845e22-f75a-4949-a0fe-9df7462da0f3
# ╠═23b8f517-f1ed-47fc-a802-21029162747e
# ╠═4eb2aeb6-373a-4dd4-aabb-fefae4f2ce1c
# ╠═adda199a-5f9f-4c4f-9d50-64fa61532403
# ╠═e1978f58-d6ba-42ea-a9ca-f34a07e99d68
# ╠═2f457efa-4df1-4def-8578-564c493e2400
# ╠═b59a09fa-9e12-4e6c-8d02-45d5664f4d46
# ╠═d2d059bb-093a-48c1-b5e4-620883901102
# ╠═a9a0da57-2dc1-4a0b-8367-1ce3789b2b6d
# ╠═6edd757a-b8d0-444a-a98d-f00a0a2ef31a
# ╠═5b754ffc-2145-411e-9900-da0aab2fce09
# ╠═0b92fbff-a7e4-4d1a-a09d-dd614308fb18
# ╠═9168fd8c-f425-46db-9b8b-091d1c04bab0
# ╠═107fb85f-96c0-441c-a7d9-53bd4f2c2c7e
# ╠═079bddd7-bddc-4a21-ba0e-4185753c6f83
# ╠═d37b98eb-92ed-4293-a616-14df794db177
# ╠═230a1baf-e984-4dde-8db1-85387945c8d5
# ╠═46d28b70-0152-49b9-8d08-457b5bde1885
# ╠═da4edb5e-aa4b-4f91-89ea-08c8b3240d86
# ╠═e75b4b50-ce81-4a0b-bc54-e76e3e85fa27
# ╠═b179584b-d9c9-4ba2-b069-af55726f9b71
# ╠═d5e8d7c5-9a21-464e-9895-19f68493b964
# ╠═199bbb2b-2402-4cb3-bd98-5150defbc8a3
# ╠═e54caf42-3978-4dd8-b4c4-16b1440b5a53
# ╠═ff94f32d-96f2-4243-9118-4fe9a449e31d
# ╠═1091a432-f576-4dab-b94a-3e9ca891eddf
# ╠═eb987440-3e6e-485f-8915-8e00d60a518d
# ╠═171c1ae3-bbeb-4b94-8423-1c0f15cd15fe
# ╠═52214a30-dbe3-4e77-a438-7053d6a3121a
# ╠═2fb93fd0-e233-4d29-b113-cfd11c122fd2
# ╠═976f8973-f4d6-447c-9d6f-c2980d8409fe
# ╠═35ea2c79-1aaa-4ea1-a259-31211dd63aea
# ╠═4aee2978-8c7c-4c2a-9821-ef14722400ca
# ╠═b8d47a90-62dd-4ffd-890b-f756c68a1dab
# ╠═067c53c1-be9f-4f32-a584-e8d8e6d8f589
# ╠═27af5a6b-9126-49aa-b2ac-9c4c5cb9b933
# ╠═599c5c67-9baf-484a-b4a6-0d99ece40643
# ╠═a06350b1-013d-46da-ab1c-e6c7545ce81b
# ╠═c1fca69b-bf9e-4341-bb72-37012bd2703b
# ╠═c7daeaf9-904a-4cf4-8d57-868c1b0cc979
# ╠═9ba3e523-5b6d-4d28-81a5-ed1ef212f781
# ╠═a2a565c5-1a4f-43a5-9193-0e1cf373e18a
# ╠═d34ff992-dbc5-4a65-8191-0f671f20d455
# ╠═d4890103-c2ef-4d19-a766-abb6cb5d319c
# ╟─740f22e3-35ce-4c75-aab6-8a913d688cf1
# ╠═e1506254-49e3-46c7-b407-900bab0167a2
# ╠═a295d5b2-1e24-49d9-9312-8d0b4c58bafe
# ╠═796f8d72-437c-4c71-b24a-cf63625ef0db
# ╟─f5f9aa89-6842-4e50-a85f-eeeafb613a1f
# ╠═db983b9d-872d-4155-b30c-28e493f8900b
# ╠═0102cab9-ffa9-49e9-b56a-e2d1fea2389c
# ╠═b900cf2f-88ee-4462-a1fd-0b65e553e28b
# ╠═9a0f1299-9517-4d6b-9a42-c948e32509e0
# ╠═cda90c96-f253-46f3-90fb-1acbcb9570ce
# ╠═03fe318c-94c8-4026-b9d2-5235cefafd1e
# ╠═bbd7d4d4-d6ab-422c-8609-f9cb2fd2af97
# ╠═5b707670-7ecb-4458-b16d-a818b0930c2b
# ╠═be0e5e49-3143-4a4d-a519-15b8acdd30c3
# ╠═4a6f61b7-c30d-4174-803e-3df380747982
# ╠═70acb7f4-510a-43dc-b389-84641e84b3c1
# ╠═5780387b-68ae-409d-b5aa-120f00456f6e
# ╠═b221a55a-566d-4922-97ba-e8c53b707075
# ╠═35814a22-4025-410a-87ec-1b07cc194819
# ╠═baef13c4-dc58-49df-b877-6d15d60212a5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
