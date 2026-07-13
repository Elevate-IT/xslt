<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript ns0" version="1.0"
                xmlns:ns0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  
  <xsl:decimal-format name="NT_DEC" decimal-separator="." grouping-separator=","/>
  
  <xsl:key name="Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate" match="//ns0:DocumentLine[ns0:Type = '1']"
    use="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate)" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Documents/ns0:Document" />
  </xsl:template>
  
  <xsl:template match="ns0:Documents/ns0:Document">
    <NAVIPWMS>
      <IDENTIFICATION>
        <PROCESSTYPE>OUTBOUNDCONFIRM</PROCESSTYPE>
        <EXTDOCNO />
        <ORIGIN />
        <CREADATE>
          <xsl:value-of select="MyScript:GetCurrentDate('yyyyMMdd')"/>
        </CREADATE>
        <CREATIME>
          <xsl:value-of select="MyScript:GetCurrentDate('HHmmdd')"/>
        </CREATIME>
      </IDENTIFICATION>
      <HEADER>
        <DATE>
          <xsl:value-of select="MyScript:ParseDate(ns0:DocumentDate,'yyyy-MM-dd','yyyyMMdd')"/>
        </DATE>
        <CUSTNOEXT>
          <xsl:value-of select="ns0:Customer/ns0:No"/>
        </CUSTNOEXT>
        <ORDTYPE>
          <xsl:value-of select="ns0:OrderTypeCode"/>
        </ORDTYPE>
        <ORDNO>
          <xsl:value-of select="ns0:No"/>
        </ORDNO>
        <CUSTREFDOC>
          <xsl:value-of select="ns0:ExternalDocumentNo"/>
        </CUSTREFDOC>
        <EXTREF>
          <!-- <xsl:choose> 
               <xsl:when test="ns0:ExternalReference != ''">
               <xsl:value-of select="ns0:ExternalReference"/>
               </xsl:when>
               <xsl:otherwise> -->
          <xsl:text>ORD</xsl:text>
          <xsl:value-of select="ns0:ExternalDocumentNo"/>
          <!--  </xsl:otherwise>
               </xsl:choose> -->
           </EXTREF>
        <EXTRAINFO>
          <xsl:value-of select="ns0:ExternalDocumentNo" />
          <xsl:text>#</xsl:text>
          <xsl:if test="ns0:ExternalReference != ''">
            <xsl:value-of select="ns0:ExternalReference" />
          </xsl:if>
        </EXTRAINFO>
        <TRANSPTYPE></TRANSPTYPE>
        <SHIPMETHOD></SHIPMETHOD>
        <TRAILER>
          <xsl:value-of select="ns0:TrailerContainerNo"/>
        </TRAILER>
        <VEHICLE>
          <xsl:value-of select="ns0:VehicleNo"/>
        </VEHICLE>
        <DRIVER></DRIVER>
        <CONTAINER>
          <xsl:value-of select="ns0:TrailerContainerNo"/>
        </CONTAINER>
        <TOTWEIGHT>
          <xsl:value-of select="format-number(ns0:GrossWeight, '###,##0.##', 'NT_DEC')"/>
        </TOTWEIGHT>
        <TOTVOLM3></TOTVOLM3>
        <TOTLOADM></TOTLOADM>
        <WEIGHT></WEIGHT>
        <WEIGHTUOM></WEIGHTUOM>
        <LOADDATE>
          <xsl:value-of select="MyScript:ParseDate(ns0:PostingDate,'yyyy-MM-dd','yyyyMMdd')"/>
        </LOADDATE>
        <LOADHOURFROM></LOADHOURFROM>
        <LOADHOURTILL></LOADHOURTILL>
        <LOADMARGIN></LOADMARGIN>
        <UNLOADDATE>
          <xsl:value-of select="MyScript:ParseDate(ns0:PlannedStartDate,'yyyy-MM-dd','yyyyMMdd')"/>
        </UNLOADDATE>
        <UNLOADHOURFROM></UNLOADHOURFROM>
        <UNLOADHOURTILL></UNLOADHOURTILL>
        <UNLOADMARGIN></UNLOADMARGIN>
        <RECEIPTNO></RECEIPTNO>
        <ADDRESSES>
          <xsl:choose>
            <xsl:when test="ns0:SenderAddress/ns0:No != ''">
              <ADDRESS>
                <ADDRTYPE>LOADING</ADDRTYPE>
                <xsl:if test="ns0:SenderAddress/ns0:ExternalNo != ''">
                  <ADDRCODE>
                    <xsl:value-of select="ns0:SenderAddress/ns0:ExternalNo" />
                  </ADDRCODE>
                </xsl:if>
                <ADDRNAME>
                  <xsl:value-of select="ns0:SenderAddress/ns0:Name" />
                </ADDRNAME>
                <ADDRESS>
                  <xsl:value-of select="ns0:SenderAddress/ns0:Address" />
                </ADDRESS>
                <ADDRESS2>
                  <xsl:value-of select="ns0:SenderAddress/ns0:Address2" />
                </ADDRESS2>
                <CNTRY>
                  <xsl:value-of select="ns0:SenderAddress/ns0:CountryRegionCode" />
                </CNTRY>
                <COUNTY>
                  <xsl:value-of select="ns0:SenderAddress/ns0:County" />
                </COUNTY>
                <CITY>
                  <xsl:value-of select="ns0:SenderAddress/ns0:City" />
                </CITY>
                <POSTC>
                  <xsl:value-of select="ns0:SenderAddress/ns0:PostCode" />
                </POSTC>
              </ADDRESS>
            </xsl:when>
            <xsl:otherwise>
              <ADDRESS>
                <ADDRTYPE>LOADING</ADDRTYPE>
                <!--<ADDRCODE>8714406999425</ADDRCODE>-->
                <ADDRNAME>
                  <xsl:value-of select="ns0:Customer/ns0:Name" />
                </ADDRNAME>
                <ADDRESS>
                  <xsl:value-of select="ns0:Customer/ns0:Address" />
                </ADDRESS>
                <ADDRESS2>
                  <xsl:value-of select="ns0:Customer/ns0:Address2" />
                </ADDRESS2>
                <CNTRY>
                  <xsl:value-of select="ns0:Customer/ns0:CountryRegionCode" />
                </CNTRY>
                <COUNTY>
                  <xsl:value-of select="ns0:Customer/ns0:County" />
                </COUNTY>
                <CITY>
                  <xsl:value-of select="ns0:Customer/ns0:City" />
                </CITY>
                <POSTC>
                  <xsl:value-of select="ns0:Customer/ns0:PostCode" />
                </POSTC>
              </ADDRESS>
            </xsl:otherwise>
          </xsl:choose>
          <ADDRESS>
            <ADDRTYPE>UNLOADING</ADDRTYPE>
            <xsl:if test="ns0:ShipToAddress/ns0:ExternalNo != ''">
              <ADDRCODE>
                <xsl:value-of select="ns0:ShipToAddress/ns0:ExternalNo" />
              </ADDRCODE>
            </xsl:if>
            <ADDRNAME>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Name"/>
            </ADDRNAME>
            <ADDRESS>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Address"/>
            </ADDRESS>
            <ADDRESS2>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Address2"/>
            </ADDRESS2>
            <CNTRY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:CountryRegionCode"/>
            </CNTRY>
            <COUNTY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:County"/>
            </COUNTY>
            <CITY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:City"/>
            </CITY>
            <POSTC>
              <xsl:value-of select="ns0:ShipToAddress/ns0:PostCode"/>
            </POSTC>
          </ADDRESS>
          <ADDRESS>
            <ADDRTYPE>CARRIER</ADDRTYPE>
            <xsl:if test="format-number(ns0:ShippingAgentCode, '#') != 'NaN'">
              <ADDRCODE>
                <xsl:value-of select="format-number(ns0:ShippingAgentCode, '#')" />
              </ADDRCODE>
            </xsl:if>
            <ADDRNAME>
              <xsl:choose>
                <xsl:when test="starts-with(ns0:ShippingAgentName, ns0:ShippingAgentCode) and
                  starts-with(ns0:ShippingAgentCode, '0') and (substring(ns0:ShippingAgentName, 12, 1) = '-')">
                  <xsl:value-of select="substring(ns0:ShippingAgentName, 14)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="ns0:ShippingAgentName" />
                </xsl:otherwise>
              </xsl:choose>
            </ADDRNAME>
            <ADDRESS></ADDRESS>
            <ADDRESS2 />
            <CNTRY></CNTRY>
            <COUNTY />
            <CITY></CITY>
            <POSTC></POSTC>
            <REF />
          </ADDRESS>
          <ADDRESS>
            <ADDRTYPE>SENDER</ADDRTYPE>
            <!--<ADDRCODE>
                 <xsl:value-of select="ns0:Customer/ns0:No"/>
                 </ADDRCODE>-->
            <ADDRNAME>
              <xsl:value-of select="ns0:Customer/ns0:Name"/>
            </ADDRNAME>
            <ADDRESS>
              <xsl:value-of select="ns0:Customer/ns0:Address"/>
            </ADDRESS>
            <ADDRESS2>
              <xsl:value-of select="ns0:Customer/ns0:Address2"/>
            </ADDRESS2>
            <CNTRY>
              <xsl:value-of select="ns0:Customer/ns0:CountryRegionCode"/>
            </CNTRY>
            <COUNTY>
              <xsl:value-of select="ns0:Customer/ns0:County"/>
            </COUNTY>
            <CITY>
              <xsl:value-of select="ns0:Customer/ns0:City"/>
            </CITY>
            <POSTC>
              <xsl:value-of select="ns0:Customer/ns0:PostCode"/>
            </POSTC>
            <REF>
              <xsl:value-of select="ns0:Customer/ns0:EANCode"/>
            </REF>
          </ADDRESS>
          <ADDRESS>
            <ADDRTYPE>ADDRESSEE</ADDRTYPE>
            <xsl:if test="ns0:ShipToAddress/ns0:ExternalNo != ''">
              <ADDRCODE>
                <xsl:value-of select="ns0:ShipToAddress/ns0:ExternalNo" />
              </ADDRCODE>
            </xsl:if>
            <ADDRNAME>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Name"/>
            </ADDRNAME>
            <ADDRESS>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Address"/>
            </ADDRESS>
            <ADDRESS2>
              <xsl:value-of select="ns0:ShipToAddress/ns0:Address2"/>
            </ADDRESS2>
            <CNTRY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:CountryRegionCode"/>
            </CNTRY>
            <COUNTY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:County"/>
            </COUNTY>
            <CITY>
              <xsl:value-of select="ns0:ShipToAddress/ns0:City"/>
            </CITY>
            <POSTC>
              <xsl:value-of select="ns0:ShipToAddress/ns0:PostCode"/>
            </POSTC>
          </ADDRESS>
        </ADDRESSES>
        
        <xsl:if test="count(ns0:DocumentLines/ns0:DocumentLine)&gt;0">
          <DETAIL>
            <xsl:for-each select="ns0:DocumentLines/ns0:DocumentLine[ns0:Type = '1'][count(. | key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate', concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate))[1]) = 1]">
              <xsl:variable name="LineKey" select="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate)" />
              <xsl:if test="$LineKey != '----'">
                <ITEMLINE>
                  <CUSTPRODCODE>
                    <xsl:value-of select="ns0:ExternalNo"/>
                  </CUSTPRODCODE>
                  <EANCODE>
                    <xsl:value-of select="ns0:EANCode"/>
                  </EANCODE>
                  <LINENO />
                  <VARIANT />
                  <EANCODEVARIANT />
                  <DESCR>
                    <xsl:value-of select="ns0:Description"/>
                  </DESCR>
                  <DESCR2>
                    <xsl:value-of select="ns0:Description2"/>
                  </DESCR2>
                  <ASKED>
                    <QUANT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###,##0.##', 'NT_DEC')"/>
                    </QUANT>
                    <QUANTUOM>
                      <xsl:value-of select="ns0:UnitofMeasureCode"/>
                    </QUANTUOM>
                    <NOOFPALLET></NOOFPALLET>
                    <WEIGHT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###,##0.##', 'NT_DEC')"/>
                    </WEIGHT>
                    <TOTWEIGHT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight), '###,##0.##', 'NT_DEC')"/>
                    </TOTWEIGHT>
                    <WEIGHTUOM>KG</WEIGHTUOM>
                    <VOL>0</VOL>
                    <TOTVOL>0</TOTVOL>
                    <VOLUOM>M3</VOLUOM>
                    <LOADM>0</LOADM>
                    <TOTLOADM>0</TOTLOADM>
                    <TRACKING>
                      <QUANT>
                        <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###,##0.##', 'NT_DEC')"/>
                      </QUANT>
                      <EARLEXPDATE />
                      <REQEXPDATE>
                        <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                      </REQEXPDATE>
                      <PRODUCTIONDATE>
                        <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                      </PRODUCTIONDATE>
                      <REQPALLET />
                      <REQSSCC />
                      <REQEXTPALLETNO />
                      <REQLOT />
                      <REQSERIAL />
                    </TRACKING>
                  </ASKED>
                  <CONFIRMED>
                    <QUANT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:QtyPosted), '###,##0.##', 'NT_DEC')"/>
                    </QUANT>
                    <QUANTUOM>
                      <xsl:value-of select="ns0:UnitofMeasureCode"/>
                    </QUANTUOM>
                    <NOOFPALLET>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:CarrierQtyPosted), '###,##0.##', 'NT_DEC')" />
                    </NOOFPALLET>
                    <WEIGHT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeightPosted) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:QtyPosted), '###,##0.##', 'NT_DEC')"/>
                    </WEIGHT>
                    <TOTWEIGHT>
                      <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeightPosted), '###,##0.##', 'NT_DEC')"/>
                    </TOTWEIGHT>
                    <WEIGHTUOM>KG</WEIGHTUOM>
                    <VOL>0</VOL>
                    <TOTVOL>0</TOTVOL>
                    <VOLUOM>M3</VOLUOM>
                    <LOADM>0</LOADM>
                    <TOTLOADM>0</TOTLOADM>
                    <xsl:if test="count(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:DocumentDetailLines/ns0:DocumentDetailLine[ns0:Posted = '1']) &gt; 0">
                      <xsl:for-each select="key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:DocumentDetailLines/ns0:DocumentDetailLine[ns0:Posted = '1']">
                        <TRACKING>
                          <QUANT>
                            <xsl:value-of select="format-number(ns0:Quantity, '###,##0.##', 'NT_DEC')"/>
                          </QUANT>
                          <SERIAL />
                          <LOT>
                            <xsl:value-of select="ns0:ExternalBatchNo"/>
                          </LOT>
                          <PALLET>
                            <xsl:value-of select="ns0:CarrierNo" />
                          </PALLET>
                          <EXPDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </EXPDATE>
                          <PRODUCTIONDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </PRODUCTIONDATE>
                          <SSCC>
                            <xsl:value-of select="ns0:CarrierNo"/>
                          </SSCC>
                          <EXTPALLETNO>
                            <xsl:value-of select="substring(ns0:CarrierNo, 9)"/>
                          </EXTPALLETNO>
                        </TRACKING>
                      </xsl:for-each>
                    </xsl:if>
                  </CONFIRMED>
                </ITEMLINE>
              </xsl:if>
            </xsl:for-each>
          </DETAIL>
        </xsl:if>
      </HEADER>
    </NAVIPWMS>
    
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
		public string GetCurrentDate(string formatOut)
		{
			return System.DateTime.Now.ToString(formatOut);
		}
      
      public string ParseEOMDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        DateTime endOfMonth = new DateTime(dateT.Year, dateT.Month, DateTime.DaysInMonth(dateT.Year, dateT.Month));
        return endOfMonth.ToString(formatOut);
      }
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
	  
	  public string Divide(double a, double b)
	  {
		return String.Format("{0:0.00}",a/b);
	  }
		]]>
  </msxsl:script>
</xsl:stylesheet>
