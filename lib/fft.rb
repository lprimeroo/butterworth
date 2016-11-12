require 'complex'
 
class Array

	def fft doinverse = false
		src = self
		n = src.length
		nlog2 = Math.log( n ) / Math.log( 2 )
		raise ArgumentError.new "Input array size must be a power of two but was '#{n}'" unless nlog2.floor - nlog2 == 0.0
		n2 = n / 2
		phi = Math::PI / n2
		if doinverse
			phi = -phi
		else
			src.collect!{|c| c /= n.to_f}
		end
 
		wt = Array.new n2
		wt.each_index { |i| wt[i] = Complex.new Math.cos(i * phi), Math.sin(i * phi) }
 
		n1 = n - 1
		j = 0
		1.upto(n1) do |i|
			m = n2
			while j >= m
				j -= m
				m /= 2
			end
			j += m
			src[i],src[j] = src[j],src[i] if j > i
		end
 
		mm = 1
		begin
			m = mm
			mm *= 2
			0.upto(m - 1) do |k|
				w = wt[ k * n2 ]
				k.step(n1, mm) do |i|
					j = i + m
					src[j] = src[i] - (temp = w * src[j])
					src[i] += temp
				end
			end
			n2 /= 2
		end while mm != n
		src
	end
end
 
class String
	def to_c
		m = @@PATTERN.match self
		return nil if m.nil?
		Complex.new m[1].to_f, m[2].to_f
	end
private
	# float_pat = /(-?\d+(?:\.\d+)?(?:e[+-]?\d+)?)/
	@@PATTERN = /^[ \t\r\n]*(-?\d+(?:\.\d+)?(?:e[+-]?\d+)?)?\s*((?:\s+|[+-])\d+(?:\.\d+)?(?:e[+-]?\d+)?i)?[ \t\r\n]*$/
end
 
values = []
$stdin.each_line do |l|
	c = l.to_c
	if c.nil?
		$stderr.puts "unmatched '#{l}'"
	else
		values << c
	end
end
INVERSE = ARGV[0] == 'inverse'
$stderr.puts INVERSE ? 'inverse' : 'forward'

values.fft(INVERSE).each {|i| puts "#{i.real} #{i.image}i"}