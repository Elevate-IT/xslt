<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-By-Item_UOM_PROD_EXP_Batch" match="//s0:LINLoop1"
           use="concat(s0:PIA[PIA01='1']/s0:C212_2/C21201, '-', s0:QTY_2/s0:C186_2/C18603, '-', 
           s0:DTM_6/s0:C507_6[C50701 = '94']/C50702, '-', s0:DTM_6/s0:C507_6[C50701 = '361']/C50702, '-', 
           s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_11/C20801)" />
  <xsl:template match="Xml">
    <Messages>
      <xsl:apply-templates select="Item/s0:EFACT_D96A_DESADV" />
    </Messages>
  </xsl:template>
  <xsl:template match="s0:EFACT_D96A_DESADV">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="normalize-space(UNB/UNB2.1)" />
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNB/UNB2.2" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:PostingDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=17]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:PostingDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM[s0:C002/C00201 = 351]/BGM02" />
          </ns0:ExternalDocumentNo>
          <ns0:VehicleNo>
            <xsl:value-of select="s0:TDTLoop1/s0:TDT[TDT01 = '25']/s0:C222/C22204" />
          </ns0:VehicleNo>
          <ns0:TrailerContainerNo>
            <xsl:value-of select="s0:TDTLoop1/s0:TDT[TDT01 = '25']/s0:C040/C04001" />
          </ns0:TrailerContainerNo>
          <ns0:AnnouncedDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=17]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:AnnouncedDate>
          <ns0:PlannedStartDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=137]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:PlannedStartDate>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701=17]/C50702,'yyyyMMddHHmm','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:SenderAddress>
            <ns0:No>
              <xsl:choose>
                <xsl:when test="normalize-space(UNB/UNB2.1) = '5013546104038'">
                  <xsl:text>ADR00189</xsl:text>
                </xsl:when>
                <!--<xsl:when test="normalize-space(UNB/UNB2.1) = ''">
                  <xsl:text>ADR00384</xsl:text>
                </xsl:when>-->
              </xsl:choose>
            </ns0:No>
          </ns0:SenderAddress>

          <xsl:if test="count(//s0:LINLoop1)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//s0:LINLoop1[count(. | key('Group-By-Item_UOM_PROD_EXP_Batch', concat(s0:PIA[PIA01='1']/s0:C212_2/C21201, '-', s0:QTY_2/s0:C186_2/C18603, '-', 
                   s0:DTM_6/s0:C507_6[C50701 = '94']/C50702, '-', s0:DTM_6/s0:C507_6[C50701 = '361']/C50702, '-', 
                   s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_11/C20801))[1]) = 1]">
                <xsl:variable name="LineKey" select="concat(s0:PIA[PIA01='1']/s0:C212_2/C21201, '-', s0:QTY_2/s0:C186_2/C18603, '-', 
                   s0:DTM_6/s0:C507_6[C50701 = '94']/C50702, '-', s0:DTM_6/s0:C507_6[C50701 = '361']/C50702, '-', 
                   s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_11/C20801)" />
                <xsl:if test="concat(s0:PIA[PIA01='1']/s0:C212_2/C21201, '-', s0:QTY_2/s0:C186_2/C18603, '-', 
                   s0:DTM_6/s0:C507_6[C50701 = '94']/C50702, '-', s0:DTM_6/s0:C507_6[C50701 = '361']/C50702, '-', 
                   s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_11/C20801) != '----'">
                  <ns0:DocumentLine>
                    <ns0:ExternalNo>
                      <xsl:value-of select="s0:PIA[PIA01='1']/s0:C212_2/C21201"/>
                    </ns0:ExternalNo>
                    <ns0:GTIN>
                      <xsl:value-of select="s0:LIN/s0:C212/C21201" />
                    </ns0:GTIN>
                    <ns0:OrderUnitofMeasureCode>
                      <xsl:value-of select="s0:QTY_2/s0:C186_2/C18603" />
                    </ns0:OrderUnitofMeasureCode>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="sum(key('Group-By-Item_UOM_PROD_EXP_Batch',$LineKey)/s0:QTY_2/s0:C186_2/C18602)" />
                    </ns0:OrderQuantity>
                    <xsl:if test="s0:DTM_6/s0:C507_6[C50701 = '94']/C50702 != ''">
                      <ns0:ProductionDate>
                        <xsl:value-of select="MyScript:ParseDate(s0:DTM_6/s0:C507_6[C50701 = '94']/C50702, 'yyyyMMdd', 'yyyy-MM-dd')" />
                      </ns0:ProductionDate>
                    </xsl:if>
                    <xsl:if test="s0:DTM_6/s0:C507_6[C50701 = '361']/C50702 != ''">
                      <ns0:ExpirationDate>
                        <xsl:value-of select="MyScript:ParseDate(s0:DTM_6/s0:C507_6[C50701 = '361']/C50702, 'yyyyMMdd', 'yyyy-MM-dd')" />
                      </ns0:ExpirationDate>
                    </xsl:if>
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01='BX']/s0:C208_11/C20801"/>
                    </ns0:ExternalBatchNo>
                    <ns0:CommentText>
                      <xsl:text>EDI</xsl:text>
                    </ns0:CommentText>
                    <!--<ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>LINENO</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="s0:LIN/LIN01" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>-->

                    <xsl:if test="count(key('Group-By-Item_UOM_PROD_EXP_Batch',$LineKey)/../s0:PACLoop1/s0:PCILoop1/s0:GINLoop1/s0:GIN[GIN01='BJ'][s0:C208/C20801!='000000000000000000']) &gt; 0">
                      <ns0:DocumentDetailLines>
                        <xsl:for-each select="key('Group-By-Item_UOM_PROD_EXP_Batch',$LineKey)/../s0:PACLoop1/s0:PCILoop1/s0:GINLoop1/s0:GIN[GIN01='BJ']">
                          <ns0:DocumentDetailLine>
                            <ns0:CarrierNo>
                              <xsl:value-of select="format-number(s0:C208/C20801, '#')"/>
                            </ns0:CarrierNo>
                            <ns0:ExternalCarrierNo>
                              <xsl:value-of select="format-number(s0:C208/C20801, '#')"/>
                            </ns0:ExternalCarrierNo>
                            <ns0:OrderQuantity>
                              <xsl:value-of select="../../../../s0:LINLoop1/s0:QTY_2/s0:C186_2/C18602"/>
                            </ns0:OrderQuantity>
                          </ns0:DocumentDetailLine>
                        </xsl:for-each>
                      </ns0:DocumentDetailLines>
                    </xsl:if>

                  </ns0:DocumentLine>
                </xsl:if>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>

        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
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

		]]>
  </msxsl:script>
</xsl:stylesheet>