
<%@ page import="java.util.LinkedList,
                 java.util.List,
                 java.text.SimpleDateFormat,
                 java.util.ArrayList,
                 java.util.Iterator,
                 org.housing.landreg.util.LabelValue,
                 org.housing.landreg.db.DataAccessManager,
                 org.housing.landreg.business.LandTO"%>
<jsp:useBean id="newLand" scope="page" class="org.housing.landreg.business.LandTO" />
<jsp:setProperty name="newLand" property="*" />
<%
    DataAccessManager dataAccessManager = new DataAccessManager();

    if (request.getParameter("doUpdate") == null) {  //data comes from the database
        if (request.getParameter("campId") == null) {
            response.sendRedirect("SearchCamps.jsp");
            return;
        }
        int campID = 0;
        try {
            campID = Integer.parseInt(request.getParameter("campId"));
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("SearchCamps.jsp");
            return;
        }

        LandTO camp = dataAccessManager.searchLandsCamp(campID);
        newCamp.copyFrom(camp);

        //reset the date
        newCamp.setUpdateDate(new java.util.Date());

        session.setAttribute("CAMP_ID",new Integer(newCamp.getCampId()));
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>


<title>:: Sahana :: Housing Scheme - Add Land</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="common/style.css" rel="stylesheet" type="text/css">
<script language='javascript' src='commonControls/popupcal/popcalendar.js'></script>
<script type="text/javascript">

function validateForm()
{
    if(document.newLand.landName.value == "")
    {
        alert("Land Name must have a value");
        document.newLand.landName.focus();
        return false;
    }
<%--        alert("pro "+ document.newLand.provinceCode.value);--%>
    if(document.newLand.provinceCode.value == "-1" || document.newLand.provinceCode.value == "")
    {
        alert("Province must be selected");
        document.newLand.provinceCode.focus();
        return false;
    }

    if(document.newLand.districtId.value == "-1" || document.newLand.districtId.value == "")
    {
        alert("District must be selected");
        document.newLand.districtId.focus();
        return false;
    }

    if(document.newLand.divisionId.value == "-1" || document.newLand.divisionId.value == "")
    {
        alert("Division must be selected");
        document.newLand.divisionId.focus();
        return false;
    }

    if(document.newLand.measurement.value == "")
    {
        alert(" Measurement must have a value");
        document.newLand.measurement.focus();
        return false;
    }

    if(document.newLand.areaId.value == "-1" || document.newLand.areaId.value == "" )
    {
        alert(" Area must have a value");
        document.newLand.areaId.focus();
        return false;
    }

    if(document.newLand.ownedById.value == "-1" || document.newLand.ownedById.value == "" )
    {
        alert(" Owned By must have a value");
        document.newLand.ownedById.focus();
        return false;
    }

    if(document.newLand.termId.value == "-1" || document.newLand.termId.value == "" )
    {
        alert(" Term must have a value");
        document.newLand.termId.focus();
        return false;
    }

    document.newLand.doInsert="doInsert";
    document.newLand.submit();

}



<% DataAccessManager dm = new DataAccessManager(); %>

 <%List listcode;
     for (int j = 1;j < 10; j++) {
         %>var provCode<%=j%> = new Array( <%
        listcode = dm.listDistrictwithProvince(""+j);
         for (int i = 0; i <listcode.size(); i++) {
           if (i==0){
               out.print("\"" + ((LabelValue)listcode.get(i)).getValue() +"\"");
           }else{
              out.print("," + "\""+((LabelValue)listcode.get(i)).getValue() +"\"" );
         }
          }
             %>);
        var prov<%=j%> = new Array( <%
        for (int i = 0; i <listcode.size(); i++) {
          if (i==0){
           out.print("\"" + ((LabelValue)listcode.get(i)).getLabel() +"\"");
         }else{
          out.print("," + "\""+((LabelValue)listcode.get(i)).getLabel() +"\"" );
        }
       }
         %>);
         <%}
             out.println();
 %>
 <%List divlistCode;
     List alldisCode = dm.listDistrict();
     String disNameCode;
     String dicCode;
     for (int j = 0 ;j < alldisCode.size(); j++) {
            disNameCode =((LabelValue)alldisCode.get(j)).getLabel();
            dicCode = ((LabelValue)alldisCode.get(j)).getValue();
             %>var districtCode<%=dicCode%> = new Array( <%
               divlistCode = dm.listDivisionsforDistrcit(disNameCode);
             for (int i = 0; i <divlistCode.size(); i++) {
               if (i==0){
                   out.print("\"" + ((LabelValue)divlistCode.get(i)).getValue() +"\"");
               }else{
                  out.print("," + "\""+((LabelValue)divlistCode.get(i)).getValue() +"\"" );
             }
           }
                 %>);
          var district<%=dicCode%> = new Array( <%
          for (int i = 0; i <divlistCode.size(); i++) {
           if (i==0){
               out.print("\"" + ((LabelValue)divlistCode.get(i)).getLabel() +"\"");
           }else{
               out.print("," + "\""+((LabelValue)divlistCode.get(i)).getLabel() +"\"" );
          }
        }
         %>);
         <%
     }
             out.println();
 %>

  function listDistrict(){
     var provincecode = document.newLand.provinceCode.value;
     var optionList = document.newLand.districtId.options;
     optionList.length = 0;
     var divisionList = document.newLand.divisionId.options;
     divisionList.length = 0;
     var prov = eval("prov"+provincecode);
     var tempproveCode = eval("provCode"+provincecode);
     for (i=0;i< prov.length ;i++){
      var option = new Option(prov[i],tempproveCode[i]);
      optionList.add(option,i);
     }
   }

 function listDivisions(){
      var provincecode = document.newLand.provinceCode.value;
      var distrcictCode = document.newLand.districtId.selectedIndex ;
      var divisionList = document.newLand.divisionId.options;
      divisionList.length =0;
<%--      var divCode = 0;--%>
      var divisionCode = document.newLand.districtId.value;
<%--      alert(divisionCode);--%>
<%--      for(j=0 ; j < provincecode-1 ; j++){--%>
<%--         switch (parseInt(j)) {--%>
<%--                  case 0:  divCode = divCode + prov1.length ; break;--%>
<%--                  case 1:  divCode = divCode + prov2.length ; break;--%>
<%--                  case 2:  divCode = divCode + prov3.length ; break;--%>
<%--                  case 3:  divCode = divCode + prov4.length ; break;--%>
<%--                  case 4:  divCode = divCode + prov5.length ; break;--%>
<%--                  case 5:  divCode = divCode + prov6.length ; break;--%>
<%--                  case 6:  divCode = divCode + prov7.length ; break;--%>
<%--                  case 7:  divCode = divCode + prov8.length ; break;--%>
<%--                  case 8:  divCode = divCode + prov9.length ; break;--%>
<%----%>
<%--              }--%>
<%--      }--%>
<%--      divCode = divCode + parseInt(distrcictCode);--%>

<%--      var divisions =eval("district" + divCode);--%>
<%--      var tempdivisionCode =eval("districtCode" + divCode);--%>
      var divisions =eval("district" + divisionCode);
      var tempdivisionCode =eval("districtCode" + divisionCode);
      for (i=0;i< divisions.length ;i++){
          var option = new Option(divisions[i],tempdivisionCode[i]);
          divisionList.add(option,i);
      }
    }

</script>
</head>

<body topmargin="0" leftmargin="0" onload="listDistrict();listDivisions()" >
    <table width="760" border="0" cellspacing="0" cellpadding="0">
        <td height="50" >
            <jsp:include page="common/header.inc"></jsp:include>
        </td>
        <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left">
                    <td nowrap background="images/BannerBG.jpg" class="statusBar"><img src="images/Tab.gif" width="2" height="15"></td>
                    <td nowrap background="images/BannerBG.jpg" class="statusBar"><a href="SearchLand.jsp" style="text-decoration:none"><font color="#000000">&nbsp;&nbsp;Search
                    Housing Scheme</font></a>&nbsp;&nbsp;</td>
                    <td nowrap background="images/BannerBG.jpg" class="statusBar"><img src="images/Tab.gif" width="2" height="15"></td>
                    <td width="100%" height="23" align="right" background="images/BannerBG.jpg" bgcolor="#000099" class="statusBar"><a href="LogOff.jsp" style="text-decoration:none"><font color="#000000">Log
                    off&nbsp;&nbsp;&nbsp;&nbsp;</font></a></td>
            </tr>

            </table>

          </td>
          </tr>

        </table>
        <table width="760" border="0" cellspacing="0" cellpadding="0">
             <tr>
               <td background="images/HeaderBG.jpg" colspan="2" class="formTitle">Add Land  </td>
             </tr>
         </table>


<table>
     <tr>
        <form name="newLand" action="insertLand.jsp"  >
            <table cellspacing="4"  >
                <%
                    if(errors.size() > 0) {
                         %>
                <tr>
                    <td colspan="3"class="formText" ><font color="red">Please correct the following errors</font><br></td>
                </tr>
                <%
                        newLand.setNullValsToEmpty();
                        for (Iterator iterator = errors.iterator(); iterator.hasNext();) {
                            String error = (String) iterator.next();

                 %>
                <tr>
                    <td colspan="3"class="formText" ><font color="red"><li><%=error%></li></font><br></td>
                </tr>
                <%      }
                    }
                %>

                <tr>
                    <td align="right" valign="top"  class="formText"  >Land Name</td><td><input type="text" size="20" maxlength="49"  name="landName" class="textBox"  value="<jsp:getProperty name="newLand" property="landName" />">&nbsp;<small><font color="red">*</font></small></td>
                </tr>

                <tr>
                    <td  align="right" valign="top"  class="formText" >Description&nbsp;</td>
                       <td>
                         <input type="text" size="20" maxlength="49"  name="description" class="textBox"  value="<jsp:getProperty name="newLand" property="description" />">
                       </td>
                </tr>

                 <tr>
                      <td align="left" class="formText" type="submit">Province :</td>
                      <td vAlign="top" >
                        <select name="provinceCode"  class="selectBoxes" onchange="listDistrict();listDivisions()"   >
                            <option value="">&lt;Select&gt;</option>
                            <%
                              DataAccessManager daProvience =new DataAccessManager();
                              List provinces = (List) daProvience.listProvicences();
                              for (Iterator iterator = provinces.iterator(); iterator.hasNext();) {
                                    LabelValue province = (LabelValue) iterator.next();

                                   if(newLand.getProvinceCode()!= null){
                                                if(newLand.getProvinceCode().equals(province.getValue())) {
                                    %>
                                                    <option selected  value="<%=province.getValue()%>"><%=province.getLabel()%></option>
                                    <%
                                                    continue;
                                                }
                                            }
                            %>
                                    <option value="<%=province.getValue()%>"><%=province.getLabel()%></option>
                            <%
                                }
                            %>
                        </select>&nbsp;<small><font color="red">*</font></small>
                       </td>
                 </tr>

                    <tr>
                      <td  align="left" class="formText" type="submit">District :</td>
                      <td vAlign="top" >
                        <select name="districtId" class="selectBoxes" onchange="listDivisions();" >
                            <option value="">&lt;Select&gt;</option>
                        </select>
                       </td>
                    </tr>
                    <tr>
                      <td  align="left" class="formText" type="submit">Division :</td>
                      <td vAlign="top" >
                        <select name="divisionId" class="selectBoxes" >
                            <option value="-1">&lt;Select&gt;</option>
                      </select>
                       </td>
                    </tr>


               <tr>
                    <td  align="left" valign="top"   class="formText">Area&nbsp;</td>
                    <td ><input type="text" size="20" name="measurement" class="textBox"  value="<jsp:getProperty name="newLand" property="measurement" />"><small><font color="red">*</font></small> </td>
                    <td>
                        <select name="areaId" class="selectBoxes">
                            <option value="">&lt;Select&gt;</option>
                            <%
                             DataAccessManager dat1 = new DataAccessManager();
                                // DataAccessManager da= new DataAccessManager();
                              List areas = (List) dat1.listArea();
                                for (Iterator iterator = areas.iterator(); iterator.hasNext();) {
                                    LabelValue area = (LabelValue) iterator.next();

                                    if(newLand.getAreaId()!= null){
                                          if(newLand.getAreaId().equals(area.getValue())) {
                                    %>
                                               <option selected value="<%=area.getValue()%>"><%=area.getLabel()%></option>
                                    <%
                                               continue;
                                          }
                                    }
                                    %>
                                    <option value="<%=area.getValue()%>"><%=area.getLabel()%></option>
                            <%
                                }
                            %>
                        </select>&nbsp;<small><font color="red">*</font></small>
                        <!--<input size="100" type="text" name="divInfo" readonly="true" style="border:none;" class="textBox"></input>-->
                    </td>



               </tr>


               <tr>
                            <td  align="left" valign="top"   class="formText">Owned By &nbsp;</td>

                            <td>
                                <select name="ownedById" class="selectBoxes">

                                    <option value="">&lt;Select&gt;</option>
                                    <%
                                     DataAccessManager dat4 = new DataAccessManager();
                                        // DataAccessManager da= new DataAccessManager();
                                      List ownedBys = (List) dat4.listOwnedBy();
                                        for (Iterator iterator = ownedBys.iterator(); iterator.hasNext();) {
                                            LabelValue ownedBy = (LabelValue) iterator.next();

                                            if(newLand.getOwnedById()!= null){
                                                if(newLand.getOwnedById().equals(ownedBy.getValue())) {
                                    %>
                                                    <option selected  value="<%=ownedBy.getValue()%>"><%=ownedBy.getLabel()%></option>
                                    <%
                                                    continue;
                                                }
                                            }
                                    %>
                                            <option value="<%=ownedBy.getValue()%>"><%=ownedBy.getLabel()%></option>
                                    <%
                                        }
                                    %>
                                </select>&nbsp;<small><font color="red">*</font></small>
                                <!--<input size="100" type="text" name="divInfo" readonly="true" style="border:none;" class="textBox"></input>-->
                            </td>

                            <td  align="left" valign="top"   class="formText">Comments&nbsp;</td>
                            <td ><input type="text" size="50" maxlength="49"  name="ownedByComment" class="textBox"  value="<jsp:getProperty name="newLand" property="ownedByComment" />"> </td>


               </tr>

               <tr>
                    <td  align="left" valign="top"   class="formText">Terms&nbsp;</td>

                    <td>

                        <select name="termId" class="selectBoxes">
                            <option value="">&lt;Select&gt;</option>
                            <%
                             DataAccessManager dat3 = new DataAccessManager();
                                // DataAccessManager da= new DataAccessManager();
                              List terms = (List) dat3.listTerms();
                                for (Iterator iterator = terms.iterator(); iterator.hasNext();) {
                                    LabelValue term = (LabelValue) iterator.next();

                                    if(newLand.getTermId()!= null){
                                                if(newLand.getTermId().equals(term.getValue())) {
                                    %>
                                                    <option selected  value="<%=term.getValue()%>"><%=term.getLabel()%></option>
                                    <%
                                                    continue;
                                                }
                                            }

                            %>
                                    <option value="<%=term.getValue()%>"><%=term.getLabel()%></option>
                            <%
                                }
                            %>
                        </select>&nbsp;<small><font color="red">*</font></small>
                        <!--<input size="100" type="text" name="divInfo" readonly="true" style="border:none;" class="textBox"></input>-->
                    </td>

               </tr>

               <tr>

                    <table>
                      <tr>
                              <td  align="right" valign="top"  class="formText" >GPS Co-Ordinates&nbsp;</td>
                              <td>&nbsp;&nbsp;</td>
                              <td>
                                 <input type="text" size="10" maxlength="49"  name="GPS1" class="textBox"  value="<jsp:getProperty name="newLand" property="GPS1" />">
                               </td>
                               <td>&nbsp;&nbsp;</td>
                               <td>
                                 <input type="text" size="10" maxlength="49"  name="GPS2" class="textBox"  value="<jsp:getProperty name="newLand" property="GPS2" />">
                               </td>
                               <td>&nbsp;&nbsp;</td>
                               <td>
                                 <input type="text" size="10" maxlength="49"  name="GPS3" class="textBox"  value="<jsp:getProperty name="newLand" property="GPS3" />">
                               </td>
                               <td>&nbsp;&nbsp;</td>
                               <td>
                                 <input type="text" size="10" maxlength="49"  name="GPS4" class="textBox"  value="<jsp:getProperty name="newLand" property="GPS4" />">
                               </td>

                         </tr>
                       </table>
                </tr>
                <tr>
                   <td>
                       <table>
                               <tr>
                                  <td></td>
                                  <td>
                                    <input type="reset" name="reset" value="Clear" class="buttons"/>
                                    <input type="submit" name="doUpdate" value="Update" class="buttons" />
                                </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                 <td>

                 </td>
                </tr>
            </table>

        </form>
     </tr>

 </table>

  <jsp:include page="common/footer.inc"></jsp:include>

</body>
</html>


