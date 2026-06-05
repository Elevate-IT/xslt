<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="3.0"
                xmlns:ns0="www.boltrics.nl/receivetrip:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
    <xsl:key name="Group_by_PickingInstructions" match="DELIVERY/DespatchData" use="PickingInstructions" />
    
    <xsl:template match="//Dossiers/Dossier">
        <!-- <xsl:variable name="FirstLoadCarRunSeq">
             <xsl:value-of select="DELIVERY/DespatchData[LoadSeq = '1']/FirstLoadCarRunSeq"/>
             </xsl:variable> -->
        <ns0:Message>
            <ns0:Header>
                <ns0:MessageID>
                    <xsl:value-of select="substring-after(CallOffId, 'TAS_WIMCLAES_')" />
                </ns0:MessageID>
                <ns0:CreationDateTime>
                    <xsl:value-of select="current-dateTime()" />
                </ns0:CreationDateTime>
                <ns0:ProcesAction>
                   <xsl:choose>
                        <xsl:when test="/Dossiers/Dossier/Action = 0">
                            <xsl:text>INSERT</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DELETE</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </ns0:ProcesAction>
                <ns0:FromTradingPartner>
                    <xsl:text>TAS</xsl:text>
                </ns0:FromTradingPartner>
                <ns0:ToTradingPartner>
                    <xsl:text>Wim Claes</xsl:text>
                </ns0:ToTradingPartner>
            </ns0:Header>
            <ns0:Trips>
                <ns0:Trip>
                    <ns0:Date>
                        <xsl:value-of select="xs:date(replace(/Dossiers/Dossier/Date, '([0-9]{4})/([0-9]{2})/([0-9]{2})', '$1-$2-$3')) "/>
                        <!-- <xsl:value-of select="MyScript:ParseDate(DELIVERY/DespatchData/CarrierRunDate, 'yyyyMMdd', 'yyyy-MM-dd')" /> -->
                    </ns0:Date>
                    <ns0:BuildingCode>
                        <xsl:text>GENK</xsl:text>
                    </ns0:BuildingCode>
                    <ns0:ExternalDocumentNo>
                        <xsl:value-of select="/Dossiers/Dossier/Missions/Mission/Tour/TourNumber" />
                    </ns0:ExternalDocumentNo>
                    <ns0:VehicleNo>
                        <xsl:value-of select="/Dossiers/Dossier/Missions/Mission/Tour/VehiclePlate"/>
                    </ns0:VehicleNo>
                    <ns0:ContainerNo>
                        <xsl:value-of select="/Dossiers/Dossier/Missions/Mission/Tour/TrailerPlate"/>
                    </ns0:ContainerNo>
                    <ns0:OrderTypeCode>
                        <xsl:text>TRIPOUTB</xsl:text>
                    </ns0:OrderTypeCode>
                    <ns0:ExternalRouteNo>
                        <xsl:value-of select="/Dossiers/Dossier/Missions/Mission/Tour/TourNumber" />
                        
                    </ns0:ExternalRouteNo>
                    <!-- <ns0:Attribute01>
                         <xsl:choose>
                         <xsl:when test="count(DELIVERY/DespatchData[generate-id(.) = generate-id(key('Group_by_PickingInstructions', PickingInstructions)[1])]) > 1">
                         <xsl:text>Ja</xsl:text>
                         </xsl:when>
                         <xsl:otherwise>
                         <xsl:text>Nee</xsl:text>
                         </xsl:otherwise>
                         </xsl:choose>
                         </ns0:Attribute01> -->
                    <ns0:TripLines>
                        <xsl:for-each select="Missions/Mission">
                            <ns0:TripLine>
                                <ns0:LoadingSequence>
                                    <!-- <xsl:value-of select="SequenceNumber" /> -->
                                    <xsl:value-of select="Unload/TourSequence" />
                                </ns0:LoadingSequence>
                                <ns0:ExternalDocumentNo>
                                    <xsl:value-of select="/Dossiers/Dossier/DeliveryNote" />
                                </ns0:ExternalDocumentNo>
                                <ns0:DocumentType>2</ns0:DocumentType>
                            </ns0:TripLine>
                        </xsl:for-each>
                    </ns0:TripLines>
                </ns0:Trip>
            </ns0:Trips>
        </ns0:Message>
    </xsl:template>
</xsl:stylesheet>