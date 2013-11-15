# ***************************************************************************
# *   Copyright (C) 2013 by Marek Hakala   *
# *   hakala.marek@gmail.com   *
# *
# *   Semester project for MI-RUB @ CTU FIT
# *   Topic: Bank API
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU Library General Public License as       *
# *   published by the Free Software Foundation; either version 2 of the    *
# *   License, or (at your option) any later version.                       *
# *                                                                         *
# *   This program is distributed in the hope that it will be useful,       *
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *   GNU General Public License for more details.                          *
# *                                                                         *
# *   You should have received a copy of the GNU Library General Public     *
# *   License along with this program; if not, write to the                 *
# *   Free Software Foundation, Inc.,                                       *
# *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
# ***************************************************************************/

require 'bigdecimal'

class Country
  attr_accessor :country, :currency, :amount, :code, :rate
  
  def initialize(country, currency, amount, code, rate)
    @country = country
    @currency = currency

    @amount = amount
    @code = code.upcase
    
    @rate = BigDecimal.new("#{rate}".gsub(/([,])/, '.'))
  end
  
  def getRate
    @rate.to_s(' F')
  end
  
  def to_s
    "Country: #{@country}, Currency: #{@currency}, Amount: #{@amount}, Code: #{@code}, Rate: #{@rate.to_s(' F')}"    
  end
end