<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:ns0="www.boltrics.nl/deleteshipment:v1.00"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes = "#all" >   
    <xsl:output method="xml" indent="yes" version="1.0"/>
    
    <xsl:template match="/">
        <ns0:Message>
            <ns0:Header>
                <!-- <ns0:MessageID>
                     <xsl:value-of select="substring-after(CallOffId, 'TAS_WIMCLAES_')" />
                     </ns0:MessageID> -->
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                    <xsl:text>INSERT</xsl:text>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>Ashland</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Hargo Logistics</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            
            <ns0:Documents>
                <xsl:for-each select="/ZDELVDEL/IDOC">
                    <ns0:Document>
                        <ns0:DocumentDate>
                            <xsl:value-of select="format-date(current-date(), '[D,2]/[M,2]/[Y]')"/>
                        </ns0:DocumentDate>
                        
                        <ns0:ExternalDocumentNo>
                            <xsl:value-of select="format-number(Z1DELHD/VBELN, '#')"/>
                        </ns0:ExternalDocumentNo>

                    </ns0:Document>
                </xsl:for-each>  
            </ns0:Documents>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>