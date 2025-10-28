<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Lines-by-MATNO-THT-BATCH" match="s0:EFACT_D16B_INSDES/s0:CPSLoop1" use="concat(s0:LINLoop1/s0:PIA[PIA01='5']/s0:C212_2/C21201,'-',s0:LINLoop1/s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702,'-',s0:LINLoop1/s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01 = 'BX']/s0:C208_12/C20801)" />
  <xsl:variable name="doc" select="/" ></xsl:variable>
  <xsl:template match="s0:EFACT_D16B_INSDES">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="MyScript:GetGUID()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>5413476000002</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Zeebrugge Food Logistics</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701='137']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:OrderDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701='2']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:OrderDate>
          <ns0:PostingDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701='137']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:PostingDate>
          <!--<ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701='2']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>-->
          <ns0:ArrivedDate>
            <xsl:value-of select="MyScript:ParseDate(s0:DTM/s0:C507[C50701='Z01']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:ArrivedDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM[1]/s0:C106[1]/C10601[1]" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602" />
          </ns0:ExternalReference>
          <ns0:SenderAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SU']/s0:NAD/s0:C082/C08201"/>
            </ns0:ExternalNo>
          </ns0:SenderAddress>
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C082/C08201"/>
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C080/C08001"/>
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/s0:C059/C05901"/>
            </ns0:Address>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD06"/>
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD08"/>
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='DP']/s0:NAD/NAD09"/>
            </ns0:CountryCode>
            <!--<ns0:EANCode>
              <xsl:value-of select="s0:NADLoop1[s0:NAD/NAD01='SF']/s0:NAD/s0:C082/C08201" />
            </ns0:EANCode>-->
          </ns0:ShipToAddress>
          <ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>EXTDOC</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:BGM/s0:C106/C10601" />
              </ns0:Value>
              </ns0:Attribute>
            <ns0:Attribute>
              <ns0:Code>DELITYPE</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:BGM/s0:C002/C00204"/>
              </ns0:Value>
              </ns0:Attribute>
            <ns0:Attribute>
              <ns0:Code>SALESNO</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01='SU']/s0:C082/C08202"/>
              </ns0:Value>
              </ns0:Attribute>
            <ns0:Attribute>
              <ns0:Code>SALESNA</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01='SU']/s0:C080/C08001"/>
              </ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>

          <ns0:DocumentLines>
            <!--<xsl:for-each select="//s0:CPSLoop1[count(. | key('Lines-by-MATNO-THT-BATCH', concat(s0:LINLoop1/s0:PIA[PIA01='5']/s0:C212_2/C21201,'-',s0:LINLoop1/s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702,'-',s0:LINLoop1/s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01 = 'BX']/s0:C208_12/C20801))[1]) = 1]">-->
            <xsl:variable name="LineKey" select="concat(s0:LINLoop1/s0:PIA[PIA01='5']/s0:C212_2[C21202='SA']/C21201,'-',s0:LINLoop1/s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702,'-',s0:LINLoop1/s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01 = 'BX']/s0:C208_12/C20801)" />
            <xsl:for-each select ="s0:LINLoop1">
              <!--<xsl:if test="concat(s0:LINLoop1/s0:PIA[PIA01='5']/s0:C212_2/C21201,'-',s0:LINLoop1/s0:PCILoop2/s0:DTM_10/s0:C507_10[C50701='361']/C50702,'-',s0:LINLoop1/s0:PCILoop2/s0:GINLoop2/s0:GIN_3[GIN01 = 'BX']/s0:C208_12/C20801) != ''">-->

              <ns0:DocumentLine>
                <ns0:ExternalNo>
                  <xsl:value-of select="s0:PIA[PIA01='5']/s0:C212_2[C21202='SA']/C21201"/>
                </ns0:ExternalNo>
                <ns0:OrderQuantity>
                  <xsl:value-of select="s0:QTY/s0:C186[C18601='113']/C18602" />
                </ns0:OrderQuantity>
                <xsl:if test="s0:DTM_10/s0:C507_10[C50701='361']/C50702 != ''">
                  <xsl:if test="s0:DTM_10/s0:C507_10[C50701='361']/C50702 != '00000000'">
                    <xsl:choose>
                      <xsl:when test="substring(s0:DTM_10/s0:C507_10[C50701='361']/C50702,7,2)='00'"  >
                        <ns0:ExpirationDate>
                          <xsl:value-of select="MyScript:ParseEOMDate(s0:DTM_10/s0:C507_10[C50701='361']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
                        </ns0:ExpirationDate>
                      </xsl:when>
                      <xsl:otherwise>
                        <ns0:ExpirationDate>
                          <xsl:value-of select="MyScript:ParseDate(s0:DTM_10/s0:C507_10[C50701='361']/C50702,'yyyyMMdd','yyyy-MM-dd')" />
                        </ns0:ExpirationDate>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="s0:FTX_4[s0:C107_4/C10701='ZE1P']/s0:C108_4/C10801 != ''">
                  <ns0:ExternalBatchNo>
                    <xsl:value-of select="s0:FTX_4[s0:C107_4/C10701='ZE1P']/s0:C108_4/C10801" />
                  </ns0:ExternalBatchNo>
                </xsl:if>
                <xsl:if test="s0:FTX_4[s0:C107_4/C10701='ZE2P']/s0:C108_4/C10801 != ''">
                  <ns0:ExternalBatchNo>
                    <xsl:value-of select="s0:FTX_4[s0:C107_4/C10701='ZE2P']/s0:C108_4/C10801" />
                  </ns0:ExternalBatchNo>
                </xsl:if>
                <!--<ns0:CarrierQuantity>
                    <xsl:value-of select="count(key('Lines-by-MATNO-THT-BATCH',$LineKey))" />
                  </ns0:CarrierQuantity>-->
                <ns0:Attributes>
                  <ns0:Attribute>
                    <ns0:Code>LINENO</ns0:Code>
                    <ns0:Value>
                      <xsl:value-of select="s0:PIA[PIA01='1']/s0:C212_2/C21201" />
                    </ns0:Value>
                  </ns0:Attribute>
                </ns0:Attributes>
              </ns0:DocumentLine>
              <!--</xsl:if>-->
            </xsl:for-each>

            <!--</xsl:for-each>-->
          </ns0:DocumentLines>
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