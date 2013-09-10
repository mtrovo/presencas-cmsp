#!/usr/bin/env ruby

require 'open-uri'
require 'fileutils'

class Date 
  def next_wday day
    date = Date.parse(day)
    delta= date > self ? 0 : 7
    date + delta
  end
end

def copy src_uri, dst_uri
  open(src_uri, 'rb') do |src|
    open(dst_uri, 'wb') do |dst|
      IO.copy_stream(src, dst)
    end
  end
end

def download_sip1
  date_ini=Date.new(2010,1)
  date_end=Date.new(2012,7)-1
  
  date_ini.step(date_end).select{|d| d.thursday? || d.wednesday? || d.tuesday? }.each do |cur|
    curstr=cur.strftime('%Y_%m_%d')
    ordfile="dados/Presencas_#{curstr}_ord.xml"
    unless File.exists? ordfile
      puts "baixando arquivo #{ordfile}..."
      copy("http://www2.camara.sp.gov.br/SIP/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[1\].xml",ordfile)
    end

    xordfile="dados/Presencas_#{curstr}_xord.xml"
    unless File.exists? xordfile
      puts "baixando arquivo #{xordfile}..."
      copy("http://www2.camara.sp.gov.br/SIP/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[2\].xml",xordfile)
    end
  end
end

download_sip1
