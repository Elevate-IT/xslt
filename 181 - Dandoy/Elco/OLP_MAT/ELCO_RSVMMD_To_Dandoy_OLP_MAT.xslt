<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:text>INSERT</xsl:text>
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>ELCO1070K</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>INSERT</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:CustomerItems>
        <xsl:for-each select="TextLines/Lines">
          <xsl:if test="Line != ''">
            <ns0:CustomerItem>
              <ns0:ExternalNo>
                <xsl:value-of select="MyScript:RemEmptySpace(substring(Line, 1, 18))"/>
              </ns0:ExternalNo>
              <ns0:Description>
                <xsl:value-of select="MyScript:RemEmptySpace(substring(Line, 37, 40))"/>
              </ns0:Description>
              <xsl:if test="(MyScript:RemEmptySpace(substring(Line, 107, 1)) = 'Z')">
                <ns0:ItemCategoryCode>
                  <xsl:text>SERIALREQ</xsl:text>
                </ns0:ItemCategoryCode>
              </xsl:if>
              <ns0:BaseUnitofMeasure>
                <xsl:text>PCS</xsl:text>
              </ns0:BaseUnitofMeasure>
              <ns0:UnitofMeasureatOrdering>
                <xsl:text>PCS</xsl:text>
              </ns0:UnitofMeasureatOrdering>
              <ns0:Attribute04>
                <xsl:value-of select="MyScript:RemEmptySpace(substring(Line, 19, 18))"/>
              </ns0:Attribute04>
              <ns0:UnitOfMeasures>
                <ns0:UnitOfMeasure>
                  <ns0:Code>
                    <xsl:text>PCS</xsl:text>
                  </ns0:Code>
                  <ns0:GrossWeight>
                    <xsl:value-of select="MyScript:GetDecimal(substring(Line, 77, 9))"/>
                  </ns0:GrossWeight>
                  <ns0:Cubage>
                    <xsl:value-of select="MyScript:GetDecimal(substring(Line, 86, 6))"/>
                  </ns0:Cubage>
                  <xsl:if test="(MyScript:RemEmptySpace(substring(Line, 94, 13)) != '')">
                    <ns0:EANCode>
                      <xsl:value-of select="MyScript:RemEmptySpace(substring(Line, 94, 13))"/>
                    </ns0:EANCode>
                  </xsl:if>
                  <ns0:UnitOfMeasureCarriers>
                    <ns0:UnitOfMeasureCarrier>
                      <ns0:CarrierTypeCode>
                        <xsl:text>EPAL</xsl:text>
                      </ns0:CarrierTypeCode>
                    </ns0:UnitOfMeasureCarrier>
                  </ns0:UnitOfMeasureCarriers>
                </ns0:UnitOfMeasure>
              </ns0:UnitOfMeasures>
            </ns0:CustomerItem>
          </xsl:if>
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
      
      public string[] splits;
      
      public void Split(string input, string seperator)
      {
        char seperatorChar = Convert.ToChar(seperator);
        splits = input.Split(seperatorChar);
      }
      
      public string GetFromSplitsArray(int i)
      {
        return splits[i];
      }

      public string GetNo (string input)
      {
        char[] trimStartChars = { '0', ' ' };
        input = input.TrimStart(trimStartChars);
        char[] trimChars = { ' ' };
        return input.Trim(trimChars);
      }
      
        public string RemEmptySpace (string input)
      {
        char[] trimChars = { ' ' };
        return input.Trim(trimChars);
      }
      
      public decimal GetDecimal (string input)
      {
        return Decimal.Parse(input)/1000;
      }
		]]>
  </msxsl:script>
</xsl:stylesheet>