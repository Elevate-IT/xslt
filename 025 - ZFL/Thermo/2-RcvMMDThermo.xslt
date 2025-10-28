<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/materialmasterdatathermo:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="Message" />
  </xsl:template>
  <xsl:template match="Message">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="//Header/MessageID" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="//Header/CreationDateTime" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>K000145</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Zeebrugge Food Logistics</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>

      <ns0:CustomerItems>
        <xsl:for-each select="DataMMD/POSIT">
            <ns0:CustomerItem>
              <ns0:Description>
                <xsl:value-of select="Description" />
              </ns0:Description>
              <ns0:SearchDescription>
                <xsl:value-of select="Description" />
              </ns0:SearchDescription>
              <ns0:BaseUnitofMeasure>STUK</ns0:BaseUnitofMeasure>
              <ns0:CarrierTypeCodeReceipt>EURO</ns0:CarrierTypeCodeReceipt>
              <ns0:CarrierTypeCodeShipment>EURO</ns0:CarrierTypeCodeShipment>
              <ns0:ExternalNo>
                <xsl:value-of select="ExternalNo" />
              </ns0:ExternalNo>
              <ns0:UnitofMeasureatOrdering>STUK</ns0:UnitofMeasureatOrdering>
              <ns0:UnitOfMeasures>
                <ns0:UnitOfMeasure>
                  <ns0:Code>STUK</ns0:Code>
                  <ns0:QtyperUnitofMeasure>1</ns0:QtyperUnitofMeasure>
                  <ns0:EANCode>
                    <xsl:value-of select="ExternalNo" />
                  </ns0:EANCode>
                  <ns0:UnitOfMeasureCarriers>
                    <ns0:UnitOfMeasureCarrier>
                      <ns0:CarrierTypeCode>EURO</ns0:CarrierTypeCode>
                      <ns0:QtyperUOMCode>
                        <xsl:value-of select="QtyPerCarrier" />
                      </ns0:QtyperUOMCode>
                    </ns0:UnitOfMeasureCarrier>
                  </ns0:UnitOfMeasureCarriers>
                </ns0:UnitOfMeasure>
              </ns0:UnitOfMeasures>
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