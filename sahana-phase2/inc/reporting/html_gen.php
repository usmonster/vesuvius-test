<?php
/**
 * Library for Generating xhtml Report
 *
 * PHP version 4 and 5
 *
 * LICENSE: This source file is subject to LGPL license
 * that is available through the world-wide-web at the following URI:
 * http://www.gnu.org/copyleft/lesser.html
 *
 * @author       Sanjeewa Jayasinghe <sditfac@opensource.lk>
 * @copyright  Lanka Software Foundation - http://www.opensource.lk
 * @license    http://www.gnu.org/copyleft/lesser.html GNU Lesser General Public License (LGPL)
 */
class genhtml
	{

	var $file_name;
	var $title_pos;
	var $title_txt;

	var $summary_pos;	
	var $table_pos;
	var $image_pos;	

	var $output_code;
	var $background_color;
	var $file_format;

	var $keyword;
	var $report_owner;
	var $extention;
	var $report_id;
	/*
	* The constructor 
	*/
	function genhtml()
		{
		$this->output_code .="<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html>\n<head><title>Sahana Report</title></head>\n<body>\n";
		$this->file_format = "xhtml";
		$this->extention = ".html";
		}	

	/*
	*set file name
	*/
	function setFileName($name='')
		{
			if($name=='')
			{
			$name = "sahana_report";
			}
		$this->file_name = $name;
		}
		
	function setKeyword($keyword_in='')
		{
		$this->keyword = $keyword_in;
		}

	function setOwner($owner_in='')
		{
		$this->report_owner = $owner_in;
		}

	function setReportID($report_id_in = '')
		{
		$this->report_id = $report_id_in;
		}


	function addTitle($title_in='')
		{
		$this->output_code .= "<h3 align='".$this->title_pos."'>".$title_in."</h3>\n<br>\n";
		$this->title_txt = $title_in;
		}

	function setTitlePos($title_pos_in='')
		{
		$this->title_pos = $title_pos_in;
		}
	
	function addSummary($summary_in='')
		{
		$this->output_code .= "<p align='".$this->summary_pos."'>".$summary_in."</p>\n<br>\n";
		}

	function setSummaryPos($summary_pos_in="center")
		{
		$this->summary_pos = $summary_pos_in;
		} 

	function addImage($img_path='')
		{
		$this->output_code .= "<img src='".$img_path."' align='".$this->image_pos."'/>\n<br>\n";
		}

	function setImagePos($img_pos_in='center')
		{
		$this->image_pos = $img_pos_in;
		}

	function lineBrake()
		{
		$this->output_code .= "<br>\n";
		}
	
	function addTable($header_array='',$data_array='')
		{
		$this->output_code .= "<table border='1' align='".$this->table_pos."'>\n<tr>";
		$header_keys = array_keys($header_array);
		for($i=0;$i<count($header_array);$i++)
			{
			$the_key = $header_keys[$i];
			$this->output_code .= "<th>".$header_array[$the_key]."</th>\n";
			}	
			$this->output_code .= "</tr>\n";
	
		foreach($data_array as $one_data_raw)
			{
				$data_raw_keys = array_keys($one_data_raw);
					$this->output_code .= "<tr>";
					for($i=0;$i<count($one_data_raw);$i++)
						{
							$the_data_key = $data_raw_keys[$i];
							$this->output_code .= "<td>".$one_data_raw[$the_data_key]."</td>\n";
						}	
					$this->output_code .= "</tr>\n";
			}
			$this->output_code .= "</table>\n<br>\n";
		}
	
	function setTablePos($table_pos_in='center')
		{
		$this->table_pos = $table_pos_in;	
		}

	function addLink($linkLocatoin='',$linkText='')
		{
		$this->output_code .= "<br><a href ='".$linkLocatoin."'>".$linkText."</a>";
		}

	function Output()
		{
		$this->output_code .= "</body>\n</html>\n";
		$_sd_path = str_replace('\\', '/', dirname(__FILE__));
		$_sd_path = explode('/', dirname(__FILE__));
		array_pop($_sd_path);
		array_pop($_sd_path);
		$_sd_path = implode('/', $_sd_path);
		
		$_sd_path = $_sd_path."/www/tmp/";
		$data='';

			$f=fopen($_sd_path.$this->file_name.$this->extention,'wb');
			if(!$f)
			$this->Error('Unable to create output file: '.$name);
			fwrite($f,$this->output_code,strlen($this->output_code));
			fclose($f);

		//echo "Your XHTML report has been created in ".$_sd_path;
			
		$fp = fopen($_sd_path.$this->file_name.$this->extention, "rb");
			while(!feof($fp)) 
			{
			$data .= fread($fp, 1024); 
			}
			fclose($fp);
			$data = addslashes($data);
			$data = addcslashes($data, "\0");
		
		$today = getdate();
		$current_date = $today["year"]."-".$today["mon"]."-".$today["mday"];
		$current_time = $today["hours"].":".$today["minutes"].":".$today["seconds"]; 
		$file_size = filesize($_sd_path.$this->file_name.$this->extention)/1000; 
		$file_type = $this->file_format; 
		$title = $this->title_txt;
		$file_name = $this->file_name.$this->extention;
		$the_keyword = $this->keyword;
		$the_owner = $this->report_owner;
		$the_report_ID = $this->report_id;

		global $global;
    		$db=$global["db"];

		$query = "select rep_id from report_files where rep_id = '$the_report_ID' ";	
		$res_found = $db->Execute($query);

		if($res_found->fields['rep_id'] != null)
			{
		$query="update report_files set file_name = '$file_name' , file_data='$data' , date_of_created ='$current_date' , time_of_created = '$current_time' , report_chart_owner = '$the_owner' , file_size_kb = '$file_size' , keyword = '$the_keyword' , title = '$title' where rep_id='$the_report_ID' ";
			}
		else
			{
		$query="insert into report_files(rep_id,file_name,file_data,date_of_created,time_of_created,report_chart_owner,file_type,file_size_kb,keyword,title) values ('$the_report_ID','$file_name','$data','$current_date','$current_time','$the_owner','$file_type','$file_size','$the_keyword','$title')";
			}

    		$res=$db->Execute($query);

			if($res == true)
			{
			print "<h1> Report - ".$title."</h1>";
			print "<b>Report ID : </b>".$the_report_ID." <br>";
			print "<b>Report File Name : </b>". $file_name."<br>";
			print "<b>Date : </b>".$current_date."<br>";
			print "<b>Time : </b>".$current_time."<br>";
			print "<b>Report Owner :</b>".$the_owner."<br>";
			print "<b>File Type : </b>".$file_type."<br>";
			print "<b>File Size : </b>".$file_size." kb <br>";
			print "<b>Keyword :</b>".$the_keyword."<br>";
			}
			else
			{
			print "<b>Report Creation Failed..</b>";
			}
	
		}


	}


?>