<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-PackageNo" match="//s0:Packages/s0:Package" use="s0:No" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="Counter" select="position()"></xsl:variable>
    <ns0:EFACT_D96A_DESADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>DESADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
          <UNH2.5>EAN005</UNH2.5>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>351</C00201>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="s0:ExternalDocumentNo" />
        </BGM02>
        <BGM03>5</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
          </C50702>
          <C50703>203</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>ON</C50601>
            <C50602>
              <xsl:value-of select="MyScript:ToUpper(s0:ExternalReference)" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>DQ</C50601>
            <C50602>
              <xsl:value-of select="s0:ExternalDocumentNo" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>BY</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:ExternalNo)" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
          <xsl:if test="s0:ShipToAddress/s0:Name != ''">
            <ns0:C080>
              <C08001>
                <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:Name)" />
              </C08001>
            </ns0:C080>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:Address != ''">
            <ns0:C059>
              <C05901>
                <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:Address)" />
              </C05901>
            </ns0:C059>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:City != ''">
            <NAD06>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:City)" />
            </NAD06>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:PostCode != ''">
            <NAD08>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:PostCode)" />
            </NAD08>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:CountryRegionCode != ''">
            <NAD09>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:CountryRegionCode)" />
            </NAD09>
          </xsl:if>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>SU</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:Customer/s0:EANCode" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
          <xsl:if test="s0:Customer/s0:Name != ''">
            <ns0:C080>
              <C08001>
                <xsl:value-of select="MyScript:ToUpper(s0:Customer/s0:Name)" />
              </C08001>
            </ns0:C080>
          </xsl:if>
          <xsl:if test="s0:Customer/s0:Address != ''">
            <ns0:C059>
              <C05901>
                <xsl:value-of select="MyScript:ToUpper(s0:Customer/s0:Address)" />
              </C05901>
            </ns0:C059>
          </xsl:if>
          <xsl:if test="s0:Customer/s0:City != ''">
            <NAD06>
              <xsl:value-of select="MyScript:ToUpper(s0:Customer/s0:City)" />
            </NAD06>
          </xsl:if>
          <xsl:if test="s0:Customer/s0:PostCode != ''">
            <NAD08>
              <xsl:value-of select="MyScript:ToUpper(s0:Customer/s0:PostCode)" />
            </NAD08>
          </xsl:if>
          <xsl:if test="s0:Customer/s0:CountryRegionCode != ''">
            <NAD09>
              <xsl:value-of select="MyScript:ToUpper(s0:Customer/s0:CountryRegionCode)" />
            </NAD09>
          </xsl:if>
        </ns0:NAD>
      </ns0:NADLoop1>
      <ns0:NADLoop1>
        <ns0:NAD>
          <NAD01>DP</NAD01>
          <ns0:C082>
            <C08201>
              <xsl:value-of select="s0:ShipToAddress/s0:ExternalNo" />
            </C08201>
            <C08203>9</C08203>
          </ns0:C082>
          <xsl:if test="s0:ShipToAddress/s0:Name != ''">
            <ns0:C080>
              <C08001>
                <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:Name)" />
              </C08001>
            </ns0:C080>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:Address != ''">
            <ns0:C059>
              <C05901>
                <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:Address)" />
              </C05901>
            </ns0:C059>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:City != ''">
            <NAD06>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:City)" />
            </NAD06>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:PostCode != ''">
            <NAD08>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:PostCode)" />
            </NAD08>
          </xsl:if>
          <xsl:if test="s0:ShipToAddress/s0:CountryRegionCode != ''">
            <NAD09>
              <xsl:value-of select="MyScript:ToUpper(s0:ShipToAddress/s0:CountryRegionCode)" />
            </NAD09>
          </xsl:if>
        </ns0:NAD>
      </ns0:NADLoop1>

      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>
            <xsl:value-of select="MyScript:GetNRCounter(1)"/>
          </CPS01>
        </ns0:CPS>
        <ns0:PACLoop1>
          <ns0:PAC>
            <PAC01>
              <xsl:value-of select="s0:CarrierQuantity"/>
            </PAC01>
            <ns0:C202>
              <C20201>201</C20201>
            </ns0:C202>
          </ns0:PAC>
        </ns0:PACLoop1>
      </ns0:CPSLoop1>

      <xsl:for-each select="//s0:Carriers/s0:Carrier">
        <xsl:variable name="CarrierNo" select="s0:No" />

        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetNRCounter(1)" />
            </CPS01>
            <CPS02>
              <xsl:value-of select="MyScript:GetNRCounter2(0)"/>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
              </ns0:C202>
            </ns0:PAC>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208>
                    <C20801>
                      <xsl:value-of select="substring(s0:No, 1, 18)"/>
                    </C20801>
                  </ns0:C208>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
        </ns0:CPSLoop1>

        <xsl:for-each select="s0:Contents/s0:Content">
          <xsl:variable name="DocumentLineNo" select="s0:DocumentLineNo" />
          <xsl:variable name="LineNo" select="//s0:DocumentLine[s0:LineNo=$DocumentLineNo]/s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value" />

          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>
                <xsl:value-of select="MyScript:GetNRCounter(1)" />
              </CPS01>
              <CPS02>
                <xsl:value-of select="MyScript:GetNRCounter3(0)"/>
              </CPS02>
            </ns0:CPS>
            <ns0:PACLoop1>
              <ns0:PAC>
                <PAC01>
                  <xsl:value-of select="s0:Quantity"/>
                </PAC01>
                <ns0:C202>
                  <C20201>
                    <xsl:choose>
                      <xsl:when test="s0:UnitofMeasureCode != 'CRT'">
                        <xsl:value-of select="s0:UnitofMeasureCode"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'CT'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </C20201>
                </ns0:C202>
              </ns0:PAC>
              <ns0:PCILoop1>
                <ns0:PCI>
                  <PCI01>39E</PCI01>
                </ns0:PCI>
                <xsl:if test="s0:ExpirationDate != ''">
                  <ns0:DTM_5>
                    <ns0:C507_5>
                      <C50701>361</C50701>
                      <C50702>
                        <xsl:value-of select="MyScript:ParseDate(s0:ExpirationDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
                      </C50702>
                      <C50703>102</C50703>
                    </ns0:C507_5>
                  </ns0:DTM_5>
                </xsl:if>
              </ns0:PCILoop1>
              <ns0:PCILoop1>
                <ns0:PCI>
                  <PCI01>36E</PCI01>
                </ns0:PCI>
                <xsl:if test="s0:ExternalBatchNo != ''">
                  <ns0:GINLoop1>
                    <ns0:GIN>
                      <GIN01>BX</GIN01>
                      <ns0:C208>
                        <C20801>
                          <xsl:value-of select="s0:ExternalBatchNo"/>
                        </C20801>
                      </ns0:C208>
                    </ns0:GIN>
                  </ns0:GINLoop1>
                </xsl:if>
              </ns0:PCILoop1>
            </ns0:PACLoop1>
            <ns0:LINLoop1>
              <ns0:LIN>
                <LIN01>
                  <xsl:choose>
                    <xsl:when test="//s0:DocumentLine[s0:LineNo = $DocumentLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value != ''">
                      <xsl:value-of select="//s0:DocumentLine[s0:LineNo = $DocumentLineNo]/s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="s0:DocumentLineNo"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </LIN01>
                <ns0:C212>
                  <C21201>
                    <xsl:value-of select="s0:EANCode"/>
                  </C21201>
                  <C21202>EN</C21202>
                </ns0:C212>
              </ns0:LIN>
              <ns0:IMD>
                <IMD01>F</IMD01>
                <ns0:C273>
                  <C27304>
                    <xsl:value-of select="MyScript:ToUpper(//s0:DocumentLine[s0:LineNo = $DocumentLineNo]/s0:Description)"/>
                  </C27304>
                </ns0:C273>
              </ns0:IMD>
              <ns0:QTY_2>
                <ns0:C186_2>
                  <C18601>12</C18601>
                  <C18602>
                    <xsl:value-of select="s0:Quantity"/>
                  </C18602>
                </ns0:C186_2>
              </ns0:QTY_2>
            </ns0:LINLoop1>
          </ns0:CPSLoop1>
        </xsl:for-each>
      </xsl:for-each>

      <!--<xsl:if test="count(//s0:DocumentLine[s0:Type=1][string-length(s0:QtyPosted)=0]) &gt; 0">
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetNRCounter(1)" />
            </CPS01>
            <CPS02>
              <xsl:value-of select="MyScript:GetNRCounter2(0)"/>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>1</PAC01>
              <ns0:C202>
                <C20201>201</C20201>
              </ns0:C202>
            </ns0:PAC>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>33E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BJ</GIN01>
                  <ns0:C208>
                    <C20801>000000000000000000</C20801>
                  </ns0:C208>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
        </ns0:CPSLoop1>
      </xsl:if>

      <xsl:for-each select="//s0:DocumentLine[s0:Type=1][string-length(s0:QtyPosted)=0]">
        <ns0:CPSLoop1>
          <ns0:CPS>
            <CPS01>
              <xsl:value-of select="MyScript:GetNRCounter(1)" />
            </CPS01>
            <CPS02>
              <xsl:value-of select="MyScript:GetNRCounter3(0)"/>
            </CPS02>
          </ns0:CPS>
          <ns0:PACLoop1>
            <ns0:PAC>
              <PAC01>0</PAC01>
              <ns0:C202>
                <C20201>CT</C20201>
              </ns0:C202>
            </ns0:PAC>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>39E</PCI01>
              </ns0:PCI>
              <ns0:DTM_5>
                <ns0:C507_5>
                  <C50701>361</C50701>
                  <C50702>99991231</C50702>
                  <C50703>102</C50703>
                </ns0:C507_5>
              </ns0:DTM_5>
            </ns0:PCILoop1>
            <ns0:PCILoop1>
              <ns0:PCI>
                <PCI01>36E</PCI01>
              </ns0:PCI>
              <ns0:GINLoop1>
                <ns0:GIN>
                  <GIN01>BX</GIN01>
                  <ns0:C208>
                    <C20801>DUMMY</C20801>
                  </ns0:C208>
                </ns0:GIN>
              </ns0:GINLoop1>
            </ns0:PCILoop1>
          </ns0:PACLoop1>
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:choose>
                  <xsl:when test="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value != ''">
                    <xsl:value-of select="s0:Attributes/s0:Attribute[s0:Code = 'LINENO']/s0:Value"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="s0:LineNo"/>
                  </xsl:otherwise>
                </xsl:choose>
              </LIN01>
              <ns0:C212>
                <C21201>
                  <xsl:value-of select="s0:EANCode"/>
                </C21201>
                <C21202>EN</C21202>
              </ns0:C212>
            </ns0:LIN>
            <ns0:IMD>
              <IMD01>F</IMD01>
              <ns0:C273>
                <C27304>
                  <xsl:value-of select="MyScript:ToUpper(s0:Description)"/>
                </C27304>
              </ns0:C273>
            </ns0:IMD>
            <ns0:QTY_2>
              <ns0:C186_2>
                <C18601>12</C18601>
                <C18602>0</C18602>
              </ns0:C186_2>
            </ns0:QTY_2>
          </ns0:LINLoop1>
        </ns0:CPSLoop1>
      </xsl:for-each>-->

    </ns0:EFACT_D96A_DESADV>
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
        else {
          NRCounter2 = 1;
          NRCounter3 = NRCounter;
        }
          
        return (NRCounter2).ToString();
      }
      
      public int NRCounter3;
      public string GetNRCounter3(bool increment)
      {
        if (increment){
          NRCounter3 = NRCounter - 1;
        }
          
        return (NRCounter3).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
          NRCounter += 1;
        }        
        return (NRCounter).ToString();
      }
      
      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
			public string ToUpper(string input)
			{
				return input.ToUpper();
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
    
    public string TrimEnd(string input)
    {
       return input.TrimEnd();
    }
    
    public string RemoveDiacritics(string text)
	  {
		  var normalizedString = text.Normalize(System.Text.NormalizationForm.FormD);
		  var stringBuilder = new System.Text.StringBuilder();
		  foreach (var c in normalizedString)
		  {
			  var unicodeCategory = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c);
			  if (unicodeCategory != System.Globalization.UnicodeCategory.NonSpacingMark)
			  {
				  stringBuilder.Append(c);
			  }
		  }

		  return stringBuilder.ToString().Normalize(System.Text.NormalizationForm.FormC);
	  }
    
    int PackageInQty = 0;
    int PackageOutQty = 0;
    public void SetPackageQty(int qty) {
      if (qty < 0) {
        PackageInQty += qty;
      } else {
        PackageOutQty += qty;
      }
    }
    
    public int GetPackageQty(string direction) {
      switch (direction.ToUpper())
        {
          case "IN":
          return Math.Abs(PackageInQty);
          
          case "OUT":
          return Math.Abs(PackageOutQty);
          
          default:
          return 0;
        }
    }
    
    public void ResetPackageQty() {
      PackageInQty = 0;
      PackageOutQty = 0;
    }
    
    public string GetPalletExchange(string packageType) {
      string type;
      switch (packageType.ToUpper())
        {
          case "EURO":
            type = "EUR";
            break;
          
          case "BLOK":
            type = "IND";
            break;
          
          default:
            type = packageType.ToUpper().Substring(0, 3);
            break;
        }
        
       return type + GetPackageQty("IN").ToString("000") + type + GetPackageQty("OUT").ToString("000");
    }
		]]>
  </msxsl:script>
</xsl:stylesheet>