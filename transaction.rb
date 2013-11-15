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

class Transaction
  attr_reader :date, :description, :operation, :money, :homeCurrency, :homeMoney
  attr_writer :homeCurrency, :homeMoney

  def initialize(date, description, operation, money)
    @date = date
    
    @description = description
    @operation = operation
    
    @money = money
    
    @homeCurrency = true
    @homeMoney = nil
  end

  def setMarket market
    @money.setMarket market
  end

  def to_s
    moneyInfo = "#{money}"
    
    if not @homeCurrency
      moneyInfo = "#{moneyInfo} [#{@homeMoney}]"
    end
    
    "#{date}, #{description}, [#{operationType}], #{moneyInfo}"
  end

  def operationType
    if @operation == "+"
      "IN"
    else
      "OUT"
    end
  end  
end