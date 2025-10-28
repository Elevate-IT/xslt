<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="s0:EFACT_D16B_PRODAT">
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

      <ns0:CustomerItems>
        <xsl:for-each select="s0:LINLoop1">
          <ns0:CustomerItem>
            <ns0:No2>
              <xsl:value-of select="s0:PIA_2[PIA01='1']/s0:C212_7/C21201"/>
            </ns0:No2>
            <ns0:Description>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304 != ''">
                  <xsl:value-of select="substring(s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='NL']/C27304, 1, 50)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                      <xsl:value-of select="substring(s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304, 1, 50)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304, 1, 50)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:Description>
            <ns0:SearchDescription>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                  <xsl:value-of select="substring(concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304), 1, 50)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304), 1, 50)"/>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:SearchDescription>
            <ns0:Description2>
              <xsl:choose>
                <xsl:when test="s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304 != ''">
                  <xsl:value-of select="substring(concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2[C27306='EN']/C27304), 1, 50)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring(concat(s0:PIA_2[PIA01='1']/s0:C212_7/C21201, ' - ', s0:IMDLoop1/s0:IMD_2/s0:C273_2/C27304), 1, 50)"/>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:Description2>
            <ns0:BaseUnitofMeasure>CRT</ns0:BaseUnitofMeasure>
            <ns0:ItemCategoryCode>DEEGWAREN</ns0:ItemCategoryCode>
            <ns0:CarrierTypeCodeReceipt>EUR</ns0:CarrierTypeCodeReceipt>
            <ns0:CarrierTypeCodeShipment>EUR</ns0:CarrierTypeCodeShipment>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:PIA_2[PIA01='1']/s0:C212_7/C21201"/>
            </ns0:ExternalNo>
            <ns0:Status>1</ns0:Status>
            <ns0:ReservationMethodCarrier>METHOD_8</ns0:ReservationMethodCarrier>
            <xsl:if test="(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18602 != '') and (s0:PACLoop1[s0:PAC/s0:C531/C53101='3']/s0:QTY_5/s0:C186_5/C18602 != '')">
              <ns0:DefaultCarrierQuantity>
                <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='3']/s0:QTY_5/s0:C186_5/C18602 div s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18602,'#')" />
              </ns0:DefaultCarrierQuantity>
            </xsl:if>
            <ns0:ConditionatReceipt>BEVROREN</ns0:ConditionatReceipt>
            <ns0:ConditionatShipment>BEVROREN</ns0:ConditionatShipment>
            <ns0:ConditionatStorage>BEVROREN</ns0:ConditionatStorage>
            <ns0:UnitofMeasureatReceipt>CRT</ns0:UnitofMeasureatReceipt>
            <ns0:UnitofMeasureatShipment>CRT</ns0:UnitofMeasureatShipment>
            <ns0:UnitofMeasureatStorage>CRT</ns0:UnitofMeasureatStorage>
            <ns0:ShptCarrierCalcMethod>METHOD05</ns0:ShptCarrierCalcMethod>
            <ns0:ExtBatchNoMandatoryPost>1</ns0:ExtBatchNoMandatoryPost>
            <ns0:ExtBatchNoMandatoryCreate>0</ns0:ExtBatchNoMandatoryCreate>
            <ns0:UnitOfMeasures>
              <!--<xsl:for-each select="s0:PACLoop1">-->
              <!--<xsl:if test="s0:PAC/s0:C531/C53101='2'">-->
              <ns0:UnitOfMeasure>
                <ns0:Code>CRT</ns0:Code>
                <ns0:QtyperUnitofMeasure>1</ns0:QtyperUnitofMeasure>
                <xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='LN']/s0:C174_4/C17402!=''">
                  <ns0:Length>
                    <xsl:choose>
                      <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='MTR'">
                        <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='LN']/s0:C174_4/C17402*100,'#.#')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='LN']/s0:C174_4/C17402" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:Length>
                </xsl:if>
                <xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='WD']/s0:C174_4/C17402!=''">
                  <ns0:Width>
                    <xsl:choose>
                      <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='MTR'">
                        <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='WD']/s0:C174_4/C17402*100,'#.#')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='WD']/s0:C174_4/C17402" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:Width>
                </xsl:if>
                <xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='HT']/s0:C174_4/C17402!=''">
                  <ns0:Height>
                    <xsl:choose>
                      <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='MTR'">
                        <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='HT']/s0:C174_4/C17402*100,'#.#')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='HT']/s0:C174_4/C17402" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:Height>
                </xsl:if>
                <!--<xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='ABJ']/s0:C174_4/C17402!=''">
                      <ns0:Cubage>
                        <xsl:choose>
                          <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='HLT'">
                            <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='ABJ']/s0:C174_4/C17402*100000,'#.###')" />
                          </xsl:when>
                          <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='MTQ'">
                            <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='ABJ']/s0:C174_4/C17402*1000000,'#.###')" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='ABJ']/s0:C174_4/C17402" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </ns0:Cubage>
                    </xsl:if>-->
                <xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='AAB']/s0:C174_4/C17402!=''">
                  <ns0:GrossWeight>
                    <xsl:choose>
                      <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4/s0:C174_4/C17401='GRM'">
                        <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='AAB']/s0:C174_4/C17402*1000,'#.###')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:MEA_4[s0:C502_6/C50201='AAB']/s0:C174_4/C17402" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:GrossWeight>
                </xsl:if>
                <xsl:if test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18602!=''">
                  <ns0:NetWeight>
                    <xsl:choose>
                      <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18603='GRM'">
                        <xsl:value-of select="format-number(s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18602*1000,'#.###')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:QTY_5/s0:C186_5/C18602" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </ns0:NetWeight>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:PAC/s0:C402/C40202!=''">
                    <ns0:EANCode>
                      <xsl:value-of select="s0:PACLoop1[s0:PAC/s0:C531/C53101='2']/s0:PAC/s0:C402/C40202" />
                    </ns0:EANCode>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="s0:LIN/s0:C212_6/C21201!=''">
                      <ns0:EANCode>
                        <xsl:value-of select="s0:LIN/s0:C212_6/C21201" />
                      </ns0:EANCode>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </ns0:UnitOfMeasure>
              <!--</xsl:if>-->
              <!--</xsl:for-each>-->
            </ns0:UnitOfMeasures>
            <!--<ns0:Translations>
              <xsl:for-each select="s0:IMDLoop1">
                <ns0:Translation>
                  <ns0:LanguageCode>
                    <xsl:value-of select="s0:IMD_2/s0:C273_2/C27306" />
                  </ns0:LanguageCode>
                  <ns0:Description>
                    <xsl:value-of select="s0:IMD_2/s0:C273_2/C27304"/>
                  </ns0:Description>
                </ns0:Translation>
              </xsl:for-each>
            </ns0:Translations>-->
          </ns0:CustomerItem>
        </xsl:for-each>
      </ns0:CustomerItems>

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