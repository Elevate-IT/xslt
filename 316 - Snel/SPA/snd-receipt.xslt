<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript ns0" version="1.0"
                xmlns:ns0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  
  <xsl:key name="Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo" match="//ns0:DocumentDetailLine[ns0:ExternalNo != '8900000']"
    use="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate, '-', ns0:CarrierNo)" />
  
  <xsl:key name="Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate" match="//ns0:DocumentDetailLine[ns0:ExternalNo != '8900000']"
    use="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate)" />
  
  <xsl:decimal-format name="NT_DEC" decimal-separator="," grouping-separator="."/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Documents/ns0:Document" />
  </xsl:template>
  
  <xsl:template match="ns0:Documents/ns0:Document">
    <NAVIPWMS>
      <IDENTIFICATION>
        <PROCESSTYPE>INBOUNDCONFIRM</PROCESSTYPE>
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
          <xsl:choose>
            <xsl:when test="ns0:OrderTypeCode = 'EMBALLAGE'">
              <xsl:text>EMBALAGE</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="ns0:OrderTypeCode"/>
            </xsl:otherwise>
          </xsl:choose>
        </ORDTYPE>
        <ORDNO>
          <xsl:value-of select="ns0:No"/>
        </ORDNO>
        <CUSTREFDOC>
          <xsl:choose>
            <xsl:when test="starts-with(ns0:OrderTypeCode, 'EMB')">
              <xsl:value-of select="ns0:ExternalDocumentNo"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(substring('0000000000', 1, 10 - string-length(ns0:ExternalDocumentNo)), ns0:ExternalDocumentNo)"/>
            </xsl:otherwise>
          </xsl:choose>
        </CUSTREFDOC>
        <EXTREF>
          <xsl:value-of select="ns0:ExternalReference"/>
        </EXTREF>
        <EXTRAINFO></EXTRAINFO>
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
          <xsl:value-of select="format-number(ns0:GrossWeight, '###.##0,##', 'NT_DEC')"/>
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
          <xsl:value-of select="MyScript:ParseDate(ns0:PostingDate,'yyyy-MM-dd','yyyyMMdd')"/>
        </UNLOADDATE>
        <UNLOADHOURFROM></UNLOADHOURFROM>
        <UNLOADHOURTILL></UNLOADHOURTILL>
        <UNLOADMARGIN></UNLOADMARGIN>
        <RECEIPTNO>
          <xsl:choose>
            <xsl:when test="ns0:Attributes/ns0:Attribute[ns0:Code = 'DOCREF']/ns0:Value != ''">
              <xsl:value-of select="normalize-space(ns0:Attributes/ns0:Attribute[ns0:Code = 'DOCREF']/ns0:Value)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(ns0:ExternalDocumentNo)"/>
            </xsl:otherwise>
          </xsl:choose>
        </RECEIPTNO>
        <ADDRESSES>
          <ADDRESS>
            <ADDRTYPE>LOADING</ADDRTYPE>
            <ADDRCODE>
              <xsl:choose>
                <xsl:when test="ns0:SenderAddress/ns0:EANCode != ''">
                  <xsl:value-of select="ns0:SenderAddress/ns0:EANCode" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="ns0:SenderAddress/ns0:ExternalNo" />
                </xsl:otherwise>
              </xsl:choose>
            </ADDRCODE>
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
          <ADDRESS>
            <ADDRTYPE>UNLOADING</ADDRTYPE>
            <xsl:if test="ns0:ShipToAddress/ns0:ExternalNo != ''">
              <ADDRCODE>
                <xsl:value-of select="ns0:ShipToAddress/ns0:ExternalNo"/>
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
          <xsl:if test="ns0:ShippingAgentCode != ''">
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
              <!--<REF>IOR2306694</REF>-->
            </ADDRESS>
          </xsl:if>
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
          </ADDRESS>
          <ADDRESS>
            <ADDRTYPE>ADDRESSEE</ADDRTYPE>
            <!--<ADDRCODE>10000</ADDRCODE>-->
            <ADDRNAME>WATERFRONT BV</ADDRNAME>
            <ADDRESS>COPERNICUSSTRAAT 10</ADDRESS>
            <ADDRESS2></ADDRESS2>
            <CNTRY>NL</CNTRY>
            <COUNTY></COUNTY>
            <CITY>WEERT</CITY>
            <POSTC>6003 DE</POSTC>
          </ADDRESS>
        </ADDRESSES>
        
        <xsl:variable name="EmbQty" select="sum(//ns0:DocumentLine[ns0:Type = '1'][ns0:ItemNo = 'EMBALLAGE'][ns0:ExternalNo != '8900000'][ns0:ExternalNo != '8900001'][ns0:ExternalNo != '8900006'][ns0:ExternalNo != '8900015'][ns0:ExternalNo != '8900019']/ns0:CarrierQuantity)" />
        <xsl:if test="count(//ns0:DocumentDetailLine) &gt; 0">
          <DETAIL>
            <xsl:choose>
              <xsl:when test="starts-with(ns0:OrderTypeCode, 'EMB')">
                <xsl:for-each select="//ns0:DocumentDetailLine[ns0:ExternalNo != '8900000'][count(. | key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate', concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate))[1]) = 1]">
                  <xsl:variable name="LineKey" select="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate)" />
                  <xsl:if test="$LineKey != '----'">
                    <!--<xsl:for-each select="//ns0:DocumentDetailLine">-->
                    <ITEMLINE>
                      <CUSTPRODCODE>
                        <xsl:value-of select="ns0:ExternalNo"/>
                      </CUSTPRODCODE>
                      <EANCODE>
                        <xsl:value-of select="ns0:EANCode"/>
                      </EANCODE>
                      <LINENO>
                        <xsl:choose>
                          <xsl:when test="../../ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value != ''">
                            <xsl:value-of select="../../ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="../../ns0:LineNo" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </LINENO>
                      <VARIANT />
                      <EANCODEVARIANT />
                      <DESCR>
                        <xsl:value-of select="../../ns0:Description"/>
                      </DESCR>
                      <DESCR2>
                        <xsl:value-of select="../../ns0:Description2"/>
                      </DESCR2>
                      <ASKED>
                        <QUANT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </QUANT>
                        <QUANTUOM>
                          <xsl:value-of select="ns0:UnitofMeasureCode"/>
                        </QUANTUOM>
                        <NOOFPALLET></NOOFPALLET>
                        <WEIGHT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </WEIGHT>
                        <TOTWEIGHT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight), '###.##0,##', 'NT_DEC')"/>
                        </TOTWEIGHT>
                        <WEIGHTUOM>KG</WEIGHTUOM>
                        <VOL>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Volume) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </VOL>
                        <TOTVOL>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Volume), '###.##0,##', 'NT_DEC')"/>
                        </TOTVOL>
                        <VOLUOM>M3</VOLUOM>
                        <LOADM>0</LOADM>
                        <TOTLOADM>0</TOTLOADM>
                        <TRACKING>
                          <QUANT>
                            <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                          </QUANT>
                          <EARLEXPDATE />
                          <REQEXPDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </REQEXPDATE>
                          <PRODUCTIONDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </PRODUCTIONDATE>
                          <REQPALLET />
                          <REQSSCC></REQSSCC>
                          <REQEXTPALLETNO></REQEXTPALLETNO>
                          <REQLOT>
                            <xsl:value-of select="ns0:ExternalBatchNo"/>
                          </REQLOT>
                          <REQSERIAL />
                        </TRACKING>
                      </ASKED>
                      <CONFIRMED>
                        <xsl:choose>
                          <xsl:when test="ns0:Posted=1">
                            <QUANT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </QUANT>
                            <QUANTUOM>
                              <xsl:value-of select="ns0:UnitofMeasureCode"/>
                            </QUANTUOM>
                            <NOOFPALLET>0</NOOFPALLET>
                            <WEIGHT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </WEIGHT>
                            <TOTWEIGHT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:GrossWeight), '###.##0,##', 'NT_DEC')"/>
                            </TOTWEIGHT>
                            <WEIGHTUOM>KG</WEIGHTUOM>
                            <VOL>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Volume) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </VOL>
                            <TOTVOL>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Volume), '###.##0,##', 'NT_DEC')"/>
                            </TOTVOL>
                            <VOLUOM>M3</VOLUOM>
                            <LOADM>0</LOADM>
                            <TOTLOADM>0</TOTLOADM>
                            <TRACKING>
                              <QUANT>
                                <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                              </QUANT>
                              <SERIAL />
                              <LOT>
                                <xsl:value-of select="ns0:ExternalBatchNo"/>
                              </LOT>
                              <PALLET></PALLET>
                              <EXPDATE>
                                <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                              </EXPDATE>
                              <PRODUCTIONDATE>
                                <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                              </PRODUCTIONDATE>
                              <SSCC></SSCC>
                              <EXTPALLETNO></EXTPALLETNO>
                            </TRACKING>
                          </xsl:when>
                          <!--Lege confirmed sturen wanneer lijnen niet posted zijn-->
                          <xsl:otherwise>
                            <QUANT>0</QUANT>
                            <QUANTUOM>COLLI</QUANTUOM>
                            <NOOFPALLET>0</NOOFPALLET>
                            <WEIGHT>0</WEIGHT>
                            <TOTWEIGHT>0</TOTWEIGHT>
                            <WEIGHTUOM>KG</WEIGHTUOM>
                            <VOL>0</VOL>
                            <TOTVOL>0</TOTVOL>
                            <VOLUOM>M3</VOLUOM>
                            <LOADM>0</LOADM>
                            <TOTLOADM>0</TOTLOADM>
                            <TRACKING>
                              <QUANT />
                              <SERIAL />
                              <LOT />
                              <PALLET />
                              <EXPDATE />
                              <PRODUCTIONDATE />
                              <SSCC />
                              <EXTPALLETNO />
                            </TRACKING>
                          </xsl:otherwise>
                        </xsl:choose>
                      </CONFIRMED>
                    </ITEMLINE>
                  </xsl:if>
                </xsl:for-each>
                
                <xsl:if test="(count(//ns0:DocumentLine[ns0:Type = '1'][ns0:ExternalNo = '8900000']) = 0) and ($EmbQty &gt; 0)">
                  <ITEMLINE>
                    <CUSTPRODCODE>
                      <xsl:text>8900000</xsl:text>
                    </CUSTPRODCODE>
                    <EANCODE>
                      <xsl:text>662510000019</xsl:text>
                    </EANCODE>
                    <LINENO>
                      <xsl:value-of select="//ns0:DocumentLine[ns0:Type = '1'][last()]/ns0:LineNo + 10000" />
                    </LINENO>
                    <VARIANT />
                    <EANCODEVARIANT />
                    <DESCR>
                      <xsl:text>CHEP PALLET</xsl:text>
                    </DESCR>
                    <DESCR2>
                    </DESCR2>
                    <ASKED>
                      <QUANT>
                        <xsl:value-of select="format-number($EmbQty, '###.##0,##', 'NT_DEC')"/>
                      </QUANT>
                      <QUANTUOM>
                        <xsl:text>CHEP</xsl:text>
                      </QUANTUOM>
                      <NOOFPALLET></NOOFPALLET>
                      <WEIGHT>
                        <xsl:text>21</xsl:text>
                      </WEIGHT>
                      <TOTWEIGHT>
                        <xsl:value-of select="format-number($EmbQty * 21, '###.##0,##', 'NT_DEC')"/>
                      </TOTWEIGHT>
                      <WEIGHTUOM>KG</WEIGHTUOM>
                      <VOL>0</VOL>
                      <TOTVOL>0</TOTVOL>
                      <VOLUOM>M3</VOLUOM>
                      <LOADM>0</LOADM>
                      <TOTLOADM>0</TOTLOADM>
                      <TRACKING>
                        <QUANT>
                          <xsl:value-of select="format-number($EmbQty, '###.##0,##', 'NT_DEC')"/>
                        </QUANT>
                        <EARLEXPDATE />
                        <REQEXPDATE>
                        </REQEXPDATE>
                        <PRODUCTIONDATE>
                        </PRODUCTIONDATE>
                        <REQPALLET />
                        <REQSSCC>
                        </REQSSCC>
                        <REQEXTPALLETNO>
                        </REQEXTPALLETNO>
                        <REQLOT>
                        </REQLOT>
                        <REQSERIAL />
                      </TRACKING>
                    </ASKED>
                    <CONFIRMED>
                      <QUANT>
                        <xsl:value-of select="format-number($EmbQty, '###.##0,##', 'NT_DEC')"/>
                      </QUANT>
                      <QUANTUOM>
                        <xsl:text>CHEP</xsl:text>
                      </QUANTUOM>
                      <NOOFPALLET>0</NOOFPALLET>
                      <WEIGHT>
                        <xsl:text>21</xsl:text>
                      </WEIGHT>
                      <TOTWEIGHT>
                        <xsl:value-of select="format-number($EmbQty * 21, '###.##0,##', 'NT_DEC')"/>
                      </TOTWEIGHT>
                      <WEIGHTUOM>KG</WEIGHTUOM>
                      <VOL>0</VOL>
                      <TOTVOL>0</TOTVOL>
                      <VOLUOM>M3</VOLUOM>
                      <LOADM>0</LOADM>
                      <TOTLOADM>0</TOTLOADM>
                      <TRACKING>
                        <QUANT>
                          <xsl:value-of select="format-number($EmbQty, '###.##0,##', 'NT_DEC')"/>
                        </QUANT>
                        <SERIAL />
                        <LOT />
                        <PALLET />
                        <EXPDATE />
                        <PRODUCTIONDATE />
                        <SSCC />
                        <EXTPALLETNO />
                      </TRACKING>
                    </CONFIRMED>
                  </ITEMLINE>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="//ns0:DocumentDetailLine[ns0:ExternalNo != '8900000'][count(. | key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo', concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate, '-', ns0:CarrierNo))[1]) = 1]">
                  <xsl:variable name="LineKey" select="concat(ns0:ExternalNo, '-', ns0:UnitofMeasureCode, '-', ns0:ExternalBatchNo, '-', ns0:ExpirationDate, '-', ns0:ProductionDate, '-', ns0:CarrierNo)" />
                  <xsl:if test="$LineKey != '-----'">
                    <!--<xsl:for-each select="//ns0:DocumentDetailLine">-->
                    <ITEMLINE>
                      <CUSTPRODCODE>
                        <xsl:value-of select="ns0:ExternalNo"/>
                      </CUSTPRODCODE>
                      <EANCODE>
                        <xsl:value-of select="ns0:EANCode"/>
                      </EANCODE>
                      <LINENO>
                        <xsl:choose>
                          <xsl:when test="../../ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value != ''">
                            <xsl:value-of select="../../ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="../../ns0:LineNo" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </LINENO>
                      <VARIANT />
                      <EANCODEVARIANT />
                      <DESCR>
                        <xsl:value-of select="../../ns0:Description"/>
                      </DESCR>
                      <DESCR2>
                        <xsl:value-of select="../../ns0:Description2"/>
                      </DESCR2>
                      <ASKED>
                        <QUANT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </QUANT>
                        <QUANTUOM>
                          <xsl:value-of select="ns0:UnitofMeasureCode"/>
                        </QUANTUOM>
                        <NOOFPALLET></NOOFPALLET>
                        <WEIGHT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:GrossWeight) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </WEIGHT>
                        <TOTWEIGHT>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:GrossWeight), '###.##0,##', 'NT_DEC')"/>
                        </TOTWEIGHT>
                        <WEIGHTUOM>KG</WEIGHTUOM>
                        <VOL>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Volume) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                        </VOL>
                        <TOTVOL>
                          <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Volume), '###.##0,##', 'NT_DEC')"/>
                        </TOTVOL>
                        <VOLUOM>M3</VOLUOM>
                        <LOADM>0</LOADM>
                        <TOTLOADM>0</TOTLOADM>
                        <TRACKING>
                          <QUANT>
                            <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                          </QUANT>
                          <EARLEXPDATE />
                          <REQEXPDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </REQEXPDATE>
                          <PRODUCTIONDATE>
                            <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                          </PRODUCTIONDATE>
                          <REQPALLET />
                          <REQSSCC>
                            <xsl:value-of select="ns0:CarrierNo"/>
                          </REQSSCC>
                          <REQEXTPALLETNO>
                            <xsl:value-of select="substring(ns0:CarrierNo, 9)"/>
                          </REQEXTPALLETNO>
                          <REQLOT>
                            <xsl:value-of select="ns0:ExternalBatchNo"/>
                          </REQLOT>
                          <REQSERIAL />
                        </TRACKING>
                      </ASKED>
                      <CONFIRMED>
                        <xsl:choose>
                          <xsl:when test="ns0:Posted=1">
                            <QUANT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </QUANT>
                            <QUANTUOM>
                              <xsl:value-of select="ns0:UnitofMeasureCode"/>
                            </QUANTUOM>
                            <NOOFPALLET>1</NOOFPALLET>
                            <WEIGHT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:GrossWeight) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </WEIGHT>
                            <TOTWEIGHT>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:GrossWeight), '###.##0,##', 'NT_DEC')"/>
                            </TOTWEIGHT>
                            <WEIGHTUOM>KG</WEIGHTUOM>
                            <VOL>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Volume) div sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                            </VOL>
                            <TOTVOL>
                              <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Volume), '###.##0,##', 'NT_DEC')"/>
                            </TOTVOL>
                            <VOLUOM>M3</VOLUOM>
                            <LOADM>0</LOADM>
                            <TOTLOADM>0</TOTLOADM>
                            <TRACKING>
                              <QUANT>
                                <xsl:value-of select="format-number(sum(key('Group_By_ExternalNo-UoM-Batch-ExpDate-ProdDate-CarrierNo',$LineKey)/ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                              </QUANT>
                              <SERIAL />
                              <LOT>
                                <xsl:value-of select="ns0:ExternalBatchNo"/>
                              </LOT>
                              <PALLET>
                                <xsl:value-of select="ns0:CarrierNo"/>
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
                          </xsl:when>
                          <!--Lege confirmed sturen wanneer lijnen niet posted zijn-->
                          <xsl:otherwise>
                            <QUANT>0</QUANT>
                            <QUANTUOM>COLLI</QUANTUOM>
                            <NOOFPALLET>0</NOOFPALLET>
                            <WEIGHT>0</WEIGHT>
                            <TOTWEIGHT>0</TOTWEIGHT>
                            <WEIGHTUOM>KG</WEIGHTUOM>
                            <VOL>0</VOL>
                            <TOTVOL>0</TOTVOL>
                            <VOLUOM>M3</VOLUOM>
                            <LOADM>0</LOADM>
                            <TOTLOADM>0</TOTLOADM>
                            <TRACKING>
                              <QUANT />
                              <SERIAL />
                              <LOT />
                              <PALLET />
                              <EXPDATE />
                              <PRODUCTIONDATE />
                              <SSCC />
                              <EXTPALLETNO />
                            </TRACKING>
                          </xsl:otherwise>
                        </xsl:choose>
                      </CONFIRMED>
                    </ITEMLINE>
                  </xsl:if>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:for-each select="//ns0:DocumentLine[ns0:Type = '1'][ns0:ExternalNo != '8900000'][count(ns0:DocumentDetailLines) = 0]">
              <ITEMLINE>
                <CUSTPRODCODE>
                  <xsl:value-of select="ns0:ExternalNo"/>
                </CUSTPRODCODE>
                <EANCODE>
                  <xsl:value-of select="ns0:EANCode"/>
                </EANCODE>
                <LINENO>
                  <xsl:choose>
                    <xsl:when test="ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value != ''">
                      <xsl:value-of select="ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="ns0:LineNo" />
                    </xsl:otherwise>
                  </xsl:choose>
                </LINENO>
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
                    <xsl:value-of select="format-number(ns0:Quantity, '###.##0,##', 'NT_DEC')"/>
                  </QUANT>
                  <QUANTUOM>
                    <xsl:value-of select="ns0:UnitofMeasureCode"/>
                  </QUANTUOM>
                  <NOOFPALLET></NOOFPALLET>
                  <WEIGHT>
                    <xsl:value-of select="format-number(ns0:GrossWeight div ns0:Quantity, '###.##0,##', 'NT_DEC')"/>
                  </WEIGHT>
                  <TOTWEIGHT>
                    <xsl:value-of select="format-number(ns0:GrossWeight, '###.##0,##', 'NT_DEC')"/>
                  </TOTWEIGHT>
                  <WEIGHTUOM>KG</WEIGHTUOM>
                  <VOL>0</VOL>
                  <TOTVOL>0</TOTVOL>
                  <VOLUOM>M3</VOLUOM>
                  <LOADM>0</LOADM>
                  <TOTLOADM>0</TOTLOADM>
                  <TRACKING>
                    <QUANT>
                      <xsl:value-of select="format-number(ns0:Quantity, '###.##0,##', 'NT_DEC')"/>
                    </QUANT>
                    <EARLEXPDATE />
                    <REQEXPDATE>
                      <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                    </REQEXPDATE>
                    <PRODUCTIONDATE>
                      <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                    </PRODUCTIONDATE>
                    <REQPALLET />
                    <REQSSCC>
                      <xsl:value-of select="ns0:CarrierNo"/>
                    </REQSSCC>
                    <REQEXTPALLETNO>
                      <xsl:value-of select="substring(ns0:CarrierNo, 9)"/>
                    </REQEXTPALLETNO>
                    <REQLOT>
                      <xsl:value-of select="ns0:ExternalBatchNo"/>
                    </REQLOT>
                    <REQSERIAL />
                  </TRACKING>
                </ASKED>
                <CONFIRMED>
                  <!--Lege confirmed sturen wanneer geen detail lines-->
                  <QUANT>0</QUANT>
                  <QUANTUOM>COLLI</QUANTUOM>
                  <NOOFPALLET>0</NOOFPALLET>
                  <WEIGHT>0</WEIGHT>
                  <TOTWEIGHT>0</TOTWEIGHT>
                  <WEIGHTUOM>KG</WEIGHTUOM>
                  <VOL>0</VOL>
                  <TOTVOL>0</TOTVOL>
                  <VOLUOM>M3</VOLUOM>
                  <LOADM>0</LOADM>
                  <TOTLOADM>0</TOTLOADM>
                  <TRACKING>
                    <QUANT />
                    <SERIAL />
                    <LOT />
                    <PALLET />
                    <EXPDATE />
                    <PRODUCTIONDATE />
                    <SSCC />
                    <EXTPALLETNO />
                  </TRACKING>
                </CONFIRMED>
              </ITEMLINE>
            </xsl:for-each>
            
            <xsl:for-each select="//ns0:DocumentLine[ns0:Type = '1'][ns0:ExternalNo = '8900000']">
              <ITEMLINE>
                <CUSTPRODCODE>
                  <xsl:value-of select="ns0:ExternalNo"/>
                </CUSTPRODCODE>
                <EANCODE>
                  <xsl:value-of select="ns0:EANCode"/>
                </EANCODE>
                <LINENO>
                  <xsl:choose>
                    <xsl:when test="ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value != ''">
                      <xsl:value-of select="ns0:Attributes/ns0:Attribute[ns0:Code = 'LINENO']/ns0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="ns0:LineNo" />
                    </xsl:otherwise>
                  </xsl:choose>
                </LINENO>
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
                    <xsl:value-of select="format-number(ns0:Quantity + $EmbQty, '###.##0,##', 'NT_DEC')"/>
                  </QUANT>
                  <QUANTUOM>
                    <xsl:value-of select="ns0:UnitofMeasureCode"/>
                  </QUANTUOM>
                  <NOOFPALLET></NOOFPALLET>
                  <WEIGHT>
                    <xsl:value-of select="format-number(ns0:GrossWeight div ns0:Quantity, '###.##0,##', 'NT_DEC')"/>
                  </WEIGHT>
                  <TOTWEIGHT>
                    <xsl:value-of select="format-number((ns0:Quantity + $EmbQty) * (ns0:GrossWeight div ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                  </TOTWEIGHT>
                  <WEIGHTUOM>KG</WEIGHTUOM>
                  <VOL>0</VOL>
                  <TOTVOL>0</TOTVOL>
                  <VOLUOM>M3</VOLUOM>
                  <LOADM>0</LOADM>
                  <TOTLOADM>0</TOTLOADM>
                  <TRACKING>
                    <QUANT>
                      <xsl:value-of select="format-number(ns0:Quantity + $EmbQty, '###.##0,##', 'NT_DEC')"/>
                    </QUANT>
                    <EARLEXPDATE />
                    <REQEXPDATE>
                      <xsl:value-of select="MyScript:ParseDate(ns0:ExpirationDate,'yyyy-MM-dd','yyyyMMdd')"/>
                    </REQEXPDATE>
                    <PRODUCTIONDATE>
                      <xsl:value-of select="MyScript:ParseDate(ns0:ProductionDate,'yyyy-MM-dd','yyyyMMdd')"/>
                    </PRODUCTIONDATE>
                    <REQPALLET />
                    <REQSSCC>
                      <xsl:value-of select="ns0:CarrierNo"/>
                    </REQSSCC>
                    <REQEXTPALLETNO>
                      <xsl:value-of select="substring(ns0:CarrierNo, 9)"/>
                    </REQEXTPALLETNO>
                    <REQLOT>
                      <xsl:value-of select="ns0:ExternalBatchNo"/>
                    </REQLOT>
                    <REQSERIAL />
                  </TRACKING>
                </ASKED>
                <CONFIRMED>
                  <QUANT>
                    <xsl:value-of select="format-number(ns0:Quantity + $EmbQty, '###.##0,##', 'NT_DEC')"/>
                  </QUANT>
                  <QUANTUOM>
                    <xsl:value-of select="ns0:UnitofMeasureCode"/>
                  </QUANTUOM>
                  <NOOFPALLET>0</NOOFPALLET>
                  <WEIGHT>
                    <xsl:value-of select="format-number(ns0:GrossWeight div ns0:Quantity, '###.##0,##', 'NT_DEC')"/>
                  </WEIGHT>
                  <TOTWEIGHT>
                    <xsl:value-of select="format-number((ns0:Quantity + $EmbQty) * (ns0:GrossWeight div ns0:Quantity), '###.##0,##', 'NT_DEC')"/>
                  </TOTWEIGHT>
                  <WEIGHTUOM>KG</WEIGHTUOM>
                  <VOL>0</VOL>
                  <TOTVOL>0</TOTVOL>
                  <VOLUOM>M3</VOLUOM>
                  <LOADM>0</LOADM>
                  <TOTLOADM>0</TOTLOADM>
                  <TRACKING>
                    <QUANT>
                      <xsl:value-of select="format-number(ns0:Quantity + $EmbQty, '###.##0,##', 'NT_DEC')"/>
                    </QUANT>
                    <SERIAL />
                    <LOT />
                    <PALLET />
                    <EXPDATE />
                    <PRODUCTIONDATE />
                    <SSCC />
                    <EXTPALLETNO />
                  </TRACKING>
                </CONFIRMED>
              </ITEMLINE>
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
	  
	  public string Substring(string input, int i){
		return input.Substring(i);
	  }
		]]>
  </msxsl:script>
</xsl:stylesheet>
