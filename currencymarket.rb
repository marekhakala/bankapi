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

require "net/http"
require "uri"
require "./country"

class CurrencyMarket
  attr_accessor :lastSync, :syncState, :modifiedDate, :code

  def initialize
    @url = URI.parse("http://www.cnb.cz/cs/financni_trhy/devizovy_trh/kurzy_devizoveho_trhu/denni_kurz.txt")
    @lastSync = nil
    @code = 0
    @contries = Array.new
    @syncState = "ok"
  end

  def init
    @http = Net::HTTP.new(@url.host, @url.port)
    @response = @http.request(Net::HTTP::Get.new(@url.request_uri))
  end

  def clear
    @contries.clear
  end

  def sync
    clear
    init
    parse
    @lastSync = Time.now
  end

  def offlineLoad filename
    clear
    file = File.new(filename, "r")

    index = 0
    while (line = file.gets)
      l1 = line.split(/\n/)[0]

      if index == 0
        parseHeader l1
      elsif index > 1
        @contries << parseCountry(l1)
      end

      index += 1
    end

    file.close
  end

  def findCountry code
    @contries.each do |elem|
      if elem.code == code.upcase
        return elem
      end
    end
    nil
  end

  def each
    @contries.each do |elem|
      yield elem
    end
  end

  def to_s
    output = "Sync: #{@lastSync}, Code: #{@code}, State: #{@syncState}\n"
    output = "#{output}Url: #{@url}\n"
    output = "#{output}========================================\n"
    @contries.each do |elem|
      output = "#{output}#{elem}\n"
    end

    output
  end

  def defList
    output = ""
    @contries.each do |elem|
      unless elem.nil?
        output = "#{output}#{elem.country}|#{elem.code}\n"
      end
    end
    output
  end

  private
  def parse
    # Split into lines
    body = @response.body
    list = body.split(/\n/)
    parseHeader list[0]

    (list.size-1).times do |index|
      @contries << parseCountry(list[2+index])
    end
  end

  def parseHeader line
     # Split by whitespace
     args = line.split(' ')

     # Check args count
     if args.size != 2
       @syncState = "fail"
       return
     end

     # Parse modified and code
     @modifiedDate = args[0]
     @code = args[1]
  end

  def parseCountry line
    return if line.nil?
    args = line.split('|')

    # Check args count
    if args.size != 5
      @syncState = "fail"
      return
    end

    # Parse line
    Country.new(args[0], args[1], args[2], args[3], args[4])
  end
end
