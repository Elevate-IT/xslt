<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/stockstatus:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-MATNO-THT-BATCH-STATUS" match="//s0:Message/s0:Customers/s0:Customer/s0:Carriers/s0:Carrier/s0:ContentLines/s0:CarrierContent" use="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',MyScript:ConvertStatusCode(../../s0:StatusCode))" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Customers/s0:Customer" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Customers/s0:Customer">
    <ns0:EFACT_D96A_INVRPT>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>INVRPT</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN004</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>79</C00201>
          <C00203>9</C00203>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="format-number(//s0:Header/s0:MessageID, '00000000')" />
        </BGM02>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>366</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:Header/s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>LSP</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:FromTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="//s0:ToTradingPartner" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
        </ns0:NAD>
      </ns0:NADLoop1>

      <xsl:for-each select="//s0:CarrierContent[count(. | key('Group-by-MATNO-THT-BATCH-STATUS', concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',MyScript:ConvertStatusCode(../../s0:StatusCode)))[1]) = 1]">
        <xsl:variable name="LineKey" select="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',MyScript:ConvertStatusCode(../../s0:StatusCode))" />
        <xsl:if test="concat(s0:CustomerItemNo,'-',s0:ExpirationDate,'-',s0:ExBatchNo,'-',MyScript:ConvertStatusCode(../../s0:StatusCode)) != '---'">
          <xsl:if test="sum(key('Group-by-MATNO-THT-BATCH-STATUS',$LineKey)/s0:Quantity) &gt; 0">

            <ns0:LINLoop1>
              <ns0:LIN>
                <LIN01>
                  <xsl:value-of select="MyScript:GetLinCounter()"/>
                </LIN01>
                <ns0:C212>
                  <C21201>
                    <xsl:value-of select="s0:EANCode" />
                  </C21201>
                  <C21202>EN</C21202>
                </ns0:C212>
              </ns0:LIN>
              <ns0:PIA>
                <PIA01>5</PIA01>
                <ns0:C212_2>
                  <C21201>
                    <xsl:value-of select="s0:ExternalCustomerItemNo" />
                  </C21201>
                  <C21202>SA</C21202>
                </ns0:C212_2>
              </ns0:PIA>
              <ns0:QTYLoop2>
                <ns0:QTY_2>
                  <ns0:C186_2>
                    <C18601>145</C18601>
                    <C18602>
                      <xsl:value-of select="sum(key('Group-by-MATNO-THT-BATCH-STATUS',$LineKey)/s0:Quantity)" />
                    </C18602>
                    <C18603>CT</C18603>
                  </ns0:C186_2>
                </ns0:QTY_2>
                <ns0:INV>
                  <INV01>
                    <xsl:value-of select="MyScript:ConvertStatusCode(../../s0:StatusCode)" />
                  </INV01>
                </ns0:INV>
                <ns0:RFFLoop4>
                  <ns0:RFF_4>
                    <ns0:C506_4>
                      <C50601>BT</C50601>
                      <C50602>
                        <xsl:value-of select="s0:ExBatchNo"/>
                      </C50602>
                    </ns0:C506_4>
                  </ns0:RFF_4>
                  <ns0:DTM_10>
                    <ns0:C507_10>
                      <C50701>361</C50701>
                      <C50702>
                        <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                      </C50702>
                      <C50703>102</C50703>
                    </ns0:C507_10>
                  </ns0:DTM_10>
                  <ns0:DTM_10>
                    <ns0:C507_10>
                      <C50701>94</C50701>
                      <C50702>
                        <xsl:value-of select="MyScript:ParseDate(s0:ProductionDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                      </C50702>
                      <C50703>102</C50703>
                    </ns0:C507_10>
                  </ns0:DTM_10>
                </ns0:RFFLoop4>
              </ns0:QTYLoop2>
            </ns0:LINLoop1>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </ns0:EFACT_D96A_INVRPT>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      int CPSCounter = 0;
      public string GetCPSCounter()
      {
        return (++CPSCounter).ToString();
      }
      
      public int NRCounter2 = 1;
      public string GetNRCounter2(bool increment)
      {
        if (increment)
          NRCounter2 += 1;
        return (NRCounter2).ToString();
      }
      
      public string GetNRCounter3()
      {
        return (NRCounter2 - 1).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
          NRCounter2 = 1;
          NRCounter += 1;
        }        
        return (NRCounter).ToString();
      }
      
      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 10;
          return LINCounter.ToString();
      }
      
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseDate(string input, string formatIn, string formatOut)

      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
      public int QtyOnCarrier {get;set;}
      public void AddToQtyOnCarrier(int qtyOnCarrier)
	    {       
         QtyOnCarrier = QtyOnCarrier + qtyOnCarrier;             
      }
    
      public void SetQtyOnCarrier(int qtyOnCarrier)
	    {       
         QtyOnCarrier = qtyOnCarrier;             
      }
    
      public int GetQtyOnCarrier()
	    {       
         return QtyOnCarrier;             
      }
             
      public int QtyOnCarrierRetour {get;set;}
      public void AddToQtyOnCarrierRetour(int qtyOnCarrierRetour)
	    {       
         QtyOnCarrierRetour = QtyOnCarrierRetour + qtyOnCarrierRetour;             
      }
    
      public void SetQtyOnCarrierRetour(int qtyOnCarrierRetour)
	    {       
         QtyOnCarrierRetour = qtyOnCarrierRetour;             
      }
    
      public int GetQtyOnCarrierRetour()
	    {       
         return QtyOnCarrierRetour;             
      }
      
      public string ConvertStatusCode(string StatusCode)
      {
        switch (StatusCode)
        {
          case "10-NOUVEAU":
          return "UN";
          
          case "15-CHANGER":
          return "UN";
          
          case "20-LIBRE":
          return "UN";
          
          case "50-COOL DOWN":
          return "QI";
          
          case "51-CUSTOMER RETURN":
          return "QI";
          
          case "52-QI EXPORT":
          return "QI";
          
          case "90-BLOQUE":
          return "QH";
          
          case "91-BLOQUEVIANDE":
          return "QH";
          
          default:
          return "UN";
        }
      }
		]]>
  </msxsl:script>
</xsl:stylesheet>