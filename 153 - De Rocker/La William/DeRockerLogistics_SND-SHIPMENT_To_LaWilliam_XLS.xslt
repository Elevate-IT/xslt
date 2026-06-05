<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <xsl:key name="Group-by-CarrierNo" match="//s0:DocumentDetailLine" use="s0:CarrierNo" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <xsl:variable name="DetLineKey" select="//s0:DocumentDetailLine/s0:CarrierNo" />
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
      <Styles>
        <Style ss:ID="header" ss:Name="Normal">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
      </Styles>
      <Worksheet ss:Name="Delivery">
        <Table>
          <Row ss:Index="1">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Delivery ', s0:No, ' ', translate(MyScript:ParseDate(s0:DeliveryDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/'))" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="2">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat(s0:Customer/s0:EANCode, ' ', s0:Customer/s0:Name)" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="3">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Ref.: ', s0:ExternalDocumentNo)" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="4">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Geleverd aantal: ', sum(//s0:DocumentDetailLine/s0:Quantity))" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="5">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Tot. gewicht: ', format-number(sum(//s0:DocumentDetailLine/s0:GrossWeight),'#.##'))" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="6">
            <Cell ss:Index="1">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Aantal Pal.: ', count(//s0:DocumentDetailLine[generate-id(.) = generate-id(key('Group-by-CarrierNo', s0:CarrierNo)[1])]))" />
              </Data>
            </Cell>
          </Row>

          <Row ss:Index="10">
            <Cell ss:Index="1" ss:StyleID="header">
              <Data ss:Type="String">Pallet</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="header">
              <Data ss:Type="String">SSCC Nummer</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="header">
              <Data ss:Type="String">Drager type</Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="header">
              <Data ss:Type="String">Productcode</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="header">
              <Data ss:Type="String">Variant</Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="header">
              <Data ss:Type="String">Artikel omschrijving</Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="header">
              <Data ss:Type="String">Hoev.</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="header">
              <Data ss:Type="String">Eenheid</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="header">
              <Data ss:Type="String">Hoev. (basis)</Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="header">
              <Data ss:Type="String">Lot</Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="header">
              <Data ss:Type="String">Vervaldatum</Data>
            </Cell>
            <Cell ss:Index="12" ss:StyleID="header">
              <Data ss:Type="String">Artikel status</Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="header">
              <Data ss:Type="String">Tot. gewicht (kg)</Data>
            </Cell>
          </Row>
          <xsl:for-each select="//s0:DocumentDetailLine">
            <Row ss:Index="{position() + 10}">
              <Cell ss:Index="1">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:CarrierNo"/>
                </Data>
              </Cell>
              <Cell ss:Index="2">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ExternalCarrierNo"/>
                </Data>
              </Cell>
              <Cell ss:Index="3">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:CarrierTypeCode"/>
                </Data>
              </Cell>
              <Cell ss:Index="4">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ExternalNo"/>
                </Data>
              </Cell>
              <Cell ss:Index="5">
                <Data ss:Type="String">
                  <!--<xsl:value-of select=""/>-->
                </Data>
              </Cell>
              <Cell ss:Index="6">
                <Data ss:Type="String">
                  <xsl:value-of select="../../s0:Description"/>
                </Data>
              </Cell>
              <Cell ss:Index="7">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:Quantity"/>
                </Data>
              </Cell>
              <Cell ss:Index="8">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:UnitofMeasureCode"/>
                </Data>
              </Cell>
              <Cell ss:Index="9">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:QuantityBase"/>
                </Data>
              </Cell>
              <Cell ss:Index="10">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ExternalBatchNo"/>
                </Data>
              </Cell>
              <Cell ss:Index="11">
                <Data ss:Type="String">
                  <xsl:value-of select="translate(MyScript:ParseDate(s0:ExpirationDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')"/>
                </Data>
              </Cell>
              <Cell ss:Index="12">
                <Data ss:Type="String">
                  <!--<xsl:value-of select=""/>-->
                </Data>
              </Cell>
              <Cell ss:Index="13">
                <Data ss:Type="String">
                  <xsl:value-of select="format-number(s0:GrossWeight,'#.##')"/>
                </Data>
              </Cell>
            </Row>
          </xsl:for-each>
        </Table>
      </Worksheet>

      <Worksheet ss:Name="Manco">
        <Table>
          <Row ss:Index="1">
            <Cell ss:Index="1" ss:StyleID="header">
              <Data ss:Type="String">Artikelnr.</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="header">
              <Data ss:Type="String">Artikelnr. klant</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="header">
              <Data ss:Type="String">Artikel omschrijving</Data>
            </Cell>
            <Cell ss:Index="4" ss:StyleID="header">
              <Data ss:Type="String">Gevraagd</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="header">
              <Data ss:Type="String">Eenheid</Data>
            </Cell>
            <Cell ss:Index="6" ss:StyleID="header">
              <Data ss:Type="String">Geleverd</Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="header">
              <Data ss:Type="String">Verschil</Data>
            </Cell>
          </Row>
          <xsl:for-each select="//s0:DocumentLine[s0:Type=1]">
            <xsl:variable name="CARRQTY">
              <xsl:value-of select="sum(s0:DocumentDetailLines/s0:DocumentDetailLine/s0:Quantity)"/>
            </xsl:variable>
            <xsl:if test="s0:OrderQuantity != $CARRQTY">
              <Row>
                <xsl:attribute name="ss:Index">
                  <xsl:value-of select="MyScript:GetRowNr(1)" />
                </xsl:attribute>
                <Cell ss:Index="1">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:No"/>
                  </Data>
                </Cell>
                <Cell ss:Index="2">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:ExternalNo"/>
                  </Data>
                </Cell>
                <Cell ss:Index="3">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:Description"/>
                  </Data>
                </Cell>
                <Cell ss:Index="4">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:OrderQuantity"/>
                  </Data>
                </Cell>
                <Cell ss:Index="5">
                  <Data ss:Type="String">
                    <xsl:value-of select="s0:OrderUnitofMeasureCode"/>
                  </Data>
                </Cell>
                <Cell ss:Index="6">
                  <Data ss:Type="String">
                    <xsl:value-of select="$CARRQTY"/>
                  </Data>
                </Cell>
                <Cell ss:Index="7">
                  <Data ss:Type="String">
                    <xsl:value-of select="$CARRQTY - s0:OrderQuantity"/>
                  </Data>
                </Cell>
              </Row>
            </xsl:if>
          </xsl:for-each>
        </Table>
      </Worksheet>
    </Workbook>
  </xsl:template>
  
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

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
      
      public string TrimEnd(string input)
      {
        return input.TrimEnd();
      }
      
      public int rowNr = 0;
      public string GetRowNr(int offset)
      {
        if (rowNr == 0)
          rowNr += offset;
          
        rowNr += 1;
          
        return rowNr.ToString();
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>
