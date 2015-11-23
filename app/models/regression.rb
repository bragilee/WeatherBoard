require 'matrix'

class Regression < ActiveRecord::Base


	def self.polyReg(x,y,degree)
	 	x_data=x.map{|x_i|(0..degree).map{|pow|(x_i**pow).to_f}}
	 	mx=Matrix[*x_data]
	 	my=Matrix.column_vector(y)
	 	coefficients=((mx.t*mx).inv*mx.t*my).transpose.to_a[0]

	  return coefficients
	end

	def self.getRsqr(x,y,co)

	  yAvg=y.inject{|r,a|r+a}.to_f/y.size

	  yEst=[]

	  for i in (0..x.length-1)
	    ye=getEstimate(x[i],co)
	    yEst<<ye
	  end

	  ssr=0
	  sst=0

	  for i in (0..y.length-1)
	    ssr+=(yEst[i]-yAvg)**2
	    sst+=(y[i]-yAvg)**2
	  end
	  if sst == 0.0
	  	return 0.9
	  else
	  	return ssr/sst
	  end
	end

	def self.getEstimate(x,co)
		es=0
		for j in (0..co.length-1)
	      es+=co[j]*x**j
	    end
	    return es
	end

	def self.predictValueProbability(x,y,now,period)
		a=x[0]
		x=x.map{|x|x-a}
		co=self.polyReg(x,y,1)
		probablity=self.getRsqr(x,y,co).round(2)
		px=now.to_i+period.to_i*60-a
		py=self.getEstimate(px,co).round(1)
		if !(py>0.0)
			py = 0.0
		end
		return {:predictValue=>py,:probablity=>probablity}
	end

	def self.predictWindDirValueProbability(x,y,now,period)	
		wind_dir_data = y
		frequency = Hash.new(0)
		wind_dir_data.each {|wind_dir| frequency[wind_dir] += 1}
		wind_dir_data_sort = frequency.sort_by{|key,value| value}.reverse
		count = 0
		frequency.each_value {|value| count = count + value}
		value = wind_dir_data_sort[0][0]
		frequen = wind_dir_data_sort[0][1]
		probablity = (frequen.to_f / count).round(2)
		return{:predictValue=> value, :probablity => probablity}
	end

end
