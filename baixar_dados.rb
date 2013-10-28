#!/usr/bin/env ruby

require 'open-uri'
require 'fileutils'


def copy_xml src_uri, dst_uri
  open(src_uri, 'rb') do |src|
    open(dst_uri, 'wb') do |dst|
      src_txt=src.read
      if src_txt.include? '<html' or src_txt.include? 'TotalPresencasOrdinaria="0"' or src_txt.include? 'TotalPresencasExtraordinarias="0"'
        puts "Arquivo nao disponivel: #{src_uri}"
      else
        dst.write src_txt
      end
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
      copy_xml("http://www2.camara.sp.gov.br/SIP/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[1\].xml",ordfile)
    end

    xordfile="dados/Presencas_#{curstr}_xord.xml"
    unless File.exists? xordfile
      puts "baixando arquivo #{xordfile}..."
      copy_xml("http://www2.camara.sp.gov.br/SIP/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[2\].xml",xordfile)
    end
  end
end

def download_sip2
  date_ini=Date.new(2012,7)
  date_end=Date.today
  date_ini.step(date_end).select{|d| d.thursday? || d.wednesday? || d.tuesday? }.each do |cur|
    curstr=cur.strftime('%Y_%m_%d')
    ordfile="dados/Presencas_#{curstr}_ord.xml"
    unless File.exists? ordfile
      puts "baixando arquivo #{ordfile}..."
      copy_xml("http://www2.camara.sp.gov.br/SIP2/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[1\].xml",ordfile)
    end

    xordfile="dados/Presencas_#{curstr}_xord.xml"
    unless File.exists? xordfile
      puts "baixando arquivo #{xordfile}..."
      copy_xml("http://www2.camara.sp.gov.br/SIP2/BaixarXML.aspx?arquivo=Presencas_#{curstr}_\[2\].xml",xordfile)
    end
  end
end

download_sip1
download_sip2

