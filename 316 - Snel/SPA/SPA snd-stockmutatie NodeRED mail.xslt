<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:html="http://www.w3.org/TR/REC-html40"
                exclude-result-prefixes="var xs" version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>
  
  <xsl:key name="GroupBy-Actie_ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT" match="//ItemLedgerEntry"
    use="concat(Process, '-', Actie, '-', ActieCode, '-', Taak_Nr, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
  
  <xsl:key name="GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT" match="//ItemLedgerEntry"
    use="concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="//Message/ItemLedgerEntries" />
  </xsl:template>
  
  <xsl:template match="//Message/ItemLedgerEntries">
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
    <Workbook>
      <Styles>
        <Style ss:ID="Default" ss:Name="Normal">
          <Alignment ss:Vertical="Bottom"/>
          <Borders/>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>
          <Interior/>
          <NumberFormat/>
          <Protection/>
        </Style>
        <Style ss:ID="s16">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s17">
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>
          <NumberFormat ss:Format="@"/>
        </Style>
        <Style ss:ID="s18">
          <NumberFormat ss:Format="@"/>
        </Style>
      </Styles>
      <Worksheet ss:Name="Lijst stockmutaties">
        <Table ss:ExpandedColumnCount="17" x:FullColumns="1"
               x:FullRows="1" ss:DefaultRowHeight="14.4">
          <Column ss:Width="90"/>
          <Column ss:Width="25"/>
          <Column ss:Width="48"/>
          <Column ss:Width="69"/>
          <Column ss:Width="53"/>
          <Column ss:Width="77" ss:Span="1"/>
          <Column ss:Width="65" ss:Index="8"/>
          <Column ss:Width="57"/>
          <Column ss:Width="73"/>
          <Column ss:Width="104"/>
          <Column ss:Width="60"/>
          <Column ss:Width="47"/>
          <Column ss:Width="26"/>
          <Column ss:Width="63"/>
          <Column ss:Width="69"/>
          <Column ss:Width="56"/>
          <Row name="Header">
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Lijst stockmutaties</Data>
            </Cell>
          </Row>
          <Row ss:Index="3" name="Header">
            <Cell ss:StyleID="s17">
              <Data ss:Type="String">Registratie datum</Data>
            </Cell>
            <Cell ss:MergeAcross="3" ss:StyleID="s17">
              <Data ss:Type="String">
                <xsl:choose>
                  <xsl:when test="starts-with(if (string(//CreationDateTime) != '') then format-dateTime(xs:dateTime(//CreationDateTime), '[H01]:[m01]') else '', '11')">
                    <xsl:value-of select="if (string(//CreationDateTime) != '') then format-date(xs:dateTime(//CreationDateTime) - xs:dayTimeDuration('P1D'), '[D01]/[M01]/[Y01]') else ''"/>
                    <xsl:text> 16:00:00</xsl:text>
                  </xsl:when>
                  <xsl:when test="starts-with(if (string(//CreationDateTime) != '') then format-dateTime(xs:dateTime(//CreationDateTime), '[H01]:[m01]') else '', '16')">
                    <xsl:value-of select="if (string(//CreationDateTime) != '') then format-date(xs:dateTime(//CreationDateTime), '[D01]/[M01]/[Y01]') else ''"/>
                    <xsl:text> 11:00:00</xsl:text>
                  </xsl:when>
                  <xsl:otherwise />
                </xsl:choose>
                <xsl:text>..</xsl:text>
                <xsl:value-of select="if (string(//CreationDateTime) != '') then format-dateTime(xs:dateTime(//CreationDateTime), '[D01]/[M01]/[Y01] [H01]:[m01]:00') else ''" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="5" name="Header">
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Actie</Data>
            </Cell>
            <Cell ss:StyleID="s16"/>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Order Nr.</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Taak Nr.</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Referentie</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">EAN pallet</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">EAN colli</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Productcode</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Redencode</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Omschrijving</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">SSCC</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Lotnr.</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">THT</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Colli</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Behandelaar</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Datum creatie</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Tijd creatie</Data>
            </Cell>
          </Row>
          
          <Row ss:Index="6" name="Header">
          </Row>
          
          <xsl:for-each select="ItemLedgerEntry[count(. | key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT', concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT))[1]) = 1]">
            <xsl:variable name="LineKey" select="concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
            <xsl:if test="$LineKey != '-------'">
              
              <xsl:variable name="TaakNr">
                <xsl:choose>
                  <xsl:when test="Process = 'WOV'">
                    <xsl:variable name="OrderNr" select="Order_Nr"/>
                    <xsl:value-of select="//ItemLedgerEntry[Process = 'WOV'][Order_Nr = $OrderNr][1]/Taak_Nr" />
                  </xsl:when>
                  <xsl:when test="Process = 'WMSTRANSFE'">
                    <xsl:variable name="EntryNo">
                      <xsl:choose>
                        <xsl:when test="EntryNo &lt; RelatedEntryNo">
                          <xsl:value-of select="EntryNo" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="RelatedEntryNo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="LedgerEntry" select="//ItemLedgerEntry[Process = 'WMSTRANSFE'][EntryNo = $EntryNo]" />
                    <xsl:variable name="TaskNr" select="//ItemLedgerEntry[Process = 'WMSTRANSFE'][Actie = $LedgerEntry/Actie][Productcode = $LedgerEntry/Productcode][SSCC = $LedgerEntry/SSCC][Lotnr = $LedgerEntry/Lotnr][THT = $LedgerEntry/THT][1]/Taak_Nr" />
                    <xsl:choose>
                      <xsl:when test="$LedgerEntry/Redencode = '0009'">
                        <xsl:value-of select="concat('CTAS', substring($TaskNr, 5))" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$TaskNr" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="Process = 'WMSDOCVAL'">
                    <xsl:value-of select="key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Taak_Nr[1]" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="SourceSSCC = ''">
                        <xsl:value-of select="key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Taak_Nr[1]" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:variable name="SourceSSCC" select="SourceSSCC" />
                        <xsl:value-of select="//ItemLedgerEntry[SSCC = $SourceSSCC][1]/Taak_Nr" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <Row name="Content">
                <Cell ss:StyleID="s18" name="InitialSort">
                  <Data ss:Type="String">
                    <xsl:choose>
                      <xsl:when test="Process = 'WMSDOCVAL'">
                        <xsl:variable name="CurrentTaakNr" select="Taak_Nr" />
                        <xsl:value-of select="//ItemLedgerEntry[Process = 'WMSDOCVAL'][Taak_Nr = $CurrentTaakNr][1]/EntryNo" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring($TaakNr, 6)" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Actie">
                  <Data ss:Type="String">
                    <xsl:choose>
                      <xsl:when test="Actie = 'Negatieve correctie'">
                        <xsl:text>Afboeken</xsl:text>
                      </xsl:when>
                      <xsl:when test="Actie = 'Verbruik'">
                        <xsl:text>Afboeken</xsl:text>
                      </xsl:when>
                      <xsl:when test="Actie = 'Positieve correctie'">
                        <xsl:text>Inkoop</xsl:text>
                      </xsl:when>
                      <xsl:when test="Actie = 'Inkomend'">
                        <xsl:text>Inkoop</xsl:text>
                      </xsl:when>
                      <xsl:when test="Actie = 'Output'">
                        <xsl:text>Inkoop</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="Actie" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="ActieCode">
                  <Data ss:Type="String">
                    <xsl:value-of select="ActieCode" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Order_Nr">
                  <Data ss:Type="String">
                    <xsl:value-of select="Order_Nr" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Taak_Nr">
                  <Data ss:Type="String">
                    <xsl:value-of select="$TaakNr" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Referentie">
                  <Data ss:Type="String">
                    <xsl:value-of select="Referentie" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="EAN_pallet">
                  <Data ss:Type="String">
                    <xsl:value-of select="EAN_pallet" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="EAN_colli">
                  <Data ss:Type="String">
                    <xsl:value-of select="EAN_colli" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Productcode">
                  <Data ss:Type="String">
                    <xsl:value-of select="Productcode" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Redencode">
                  <Data ss:Type="String">
                    <xsl:choose>
                      <xsl:when test="Redencode != ''">
                        <xsl:value-of select="Redencode" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>0005</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Omschrijving">
                  <Data ss:Type="String">
                    <xsl:choose>
                      <xsl:when test="Omschrijving != ''">
                        <xsl:value-of select="Omschrijving" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="Redencode = '0004'">
                            <xsl:text>MB: meerbevinding</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = '0005'">
                            <xsl:text>CO: correctie op hoeveelh. i.o</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = '0006'">
                            <xsl:text>VM: vermis</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = '0008'">
                            <xsl:text>VT: verlies/teloorgang</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = '0009'">
                            <xsl:text>Ompak regulier</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = '0011'">
                            <xsl:text>intern verbruik</xsl:text>
                          </xsl:when>
                          <xsl:when test="Redencode = ''">
                            <xsl:text>CO: correctie op hoeveelh. i.o</xsl:text>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="SSCC">
                  <Data ss:Type="String">
                    <xsl:value-of select="SSCC" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Lotnr">
                  <Data ss:Type="String">
                    <xsl:value-of select="Lotnr" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="THT">
                  <Data ss:Type="String">
                    <xsl:value-of select="format-date(xs:date(THT), '[D01]/[M01]/[Y01]')" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Colli">
                  <Data ss:Type="Number">
                    <xsl:value-of select="sum(key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Colli)" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Behandelaar">
                  <Data ss:Type="String">
                    <xsl:value-of select="Behandelaar" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Datum_creatie">
                  <Data ss:Type="String">
                    <xsl:value-of select="format-date(xs:date(Datum_creatie), '[D01]/[M01]/[Y01]')" />
                  </Data>
                </Cell>
                <Cell ss:StyleID="s18" name="Tijd_creatie">
                  <Data ss:Type="String">
                    <xsl:value-of select="Tijd_creatie" />
                  </Data>
                </Cell>
              </Row>
            </xsl:if>
          </xsl:for-each>
          
        </Table>
      </Worksheet>
    </Workbook>
  </xsl:template>
  
</xsl:stylesheet>
