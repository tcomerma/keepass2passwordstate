<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Convert KeePass XML (2.x) format ClickStudios PasswordState Import 
		format 
		Toni Comerma September 2013 
		Copyright (c) 2013 Toni Comerma - Televisió	de Catalunya. 
	    GNU GENERAL PUBLIC LICENSE - See attached License File
	    
	    Based on LiosK/keepass2keeper.xsl (https://gist.github.com/LiosK/388889)	
	-->

	<!-- Config Section -->
	<xsl:param name="PasswordListID">14</xsl:param>
	<xsl:param name="AccountType" />


	<!-- Code Section -->

	<xsl:variable name="cometa">"</xsl:variable>

	<xsl:output method="text" encoding="utf-8" />

	<xsl:template match="/">
		<!-- Header Row -->
		<xsl:text>PasswordListID,Title,UserName,Description,AccountType,Notes,URL,Password,ExpiryDate,GenericField1,GenericField2,GenericField3,GenericField4,GenericField5,GenericField6,GenericField7,GenericField8,GenericField9,GenericField10
</xsl:text>
		<xsl:apply-templates select="/KeePassFile/Root/Group" />
	</xsl:template>

	<xsl:template match="Group">
		<xsl:param name="parent" select="'/'" />
		<xsl:variable name="current" select="concat($parent, Name)" />

		<!-- list password entries -->
		<xsl:apply-templates select="Entry">
			<xsl:with-param name="group" select="$current" />
		</xsl:apply-templates>

		<!-- list entries of subgroups recursively -->
		<xsl:apply-templates select="Group">
			<xsl:with-param name="parent" select="concat($current, '/')" />
		</xsl:apply-templates>
	</xsl:template>


	<xsl:template match="Entry">
		<xsl:param name="group" />

		<!-- pack Notes and multi-line custom fields into notes field -->
		<xsl:variable name="notes">
			<xsl:if test="String[Key='Notes']/Value!=''">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="String[Key='Notes']/Value" />
					<xsl:with-param name="replace" select="$cometa" />
					<xsl:with-param name="by" select="concat($cometa,$cometa)" />
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

        <!-- Escape Double quotes in password field -->
		<xsl:variable name="password">
			<xsl:if test="String[Key='Password']/Value!=''">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="String[Key='Password']/Value" />
					<xsl:with-param name="replace" select="$cometa" />
					<xsl:with-param name="by" select="concat($cometa,$cometa)" />
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

       <!-- Escape Double quotes in password field (yes, someone put quotes in that field too)-->
		<xsl:variable name="url">
			<xsl:if test="String[Key='URL']/Value!=''">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="String[Key='URL']/Value" />
					<xsl:with-param name="replace" select="$cometa" />
					<xsl:with-param name="by" select="concat($cometa,$cometa)" />
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>

       <!-- Populate Title field with username if empty-->
		<xsl:variable name="title">
		   <xsl:choose>
              <xsl:when test="String[Key='Title']/Value=''">
                 <xsl:value-of select="String[Key='UserName']/Value"/>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:value-of select="String[Key='Title']/Value"/>
              </xsl:otherwise>
           </xsl:choose>
		</xsl:variable>
			
		<!-- Fix wrong dates (year 2999) -->	
		<xsl:variable name="date">
			<xsl:call-template name="replaceDate">
				<xsl:with-param name="value" select="Times/ExpiryTime" />
			</xsl:call-template>
		</xsl:variable>

		<!-- put tab-separated fields: Title, UserName, Password, Notes, Group, 
			URL, JSON -->
		<xsl:text>"</xsl:text>
		<xsl:value-of select="$PasswordListID" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$title" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="String[Key='UserName']/Value" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$group" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$AccountType" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$notes" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$url" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$password" />
		<xsl:text>","</xsl:text>
		<xsl:value-of select="$date" />
		<xsl:text>"&#10;</xsl:text>
	</xsl:template>

	<!-- replace $pattern in $subject with $replace -->
	<xsl:template name="replace">
		<xsl:param name="subject" />
		<xsl:param name="pattern" />
		<xsl:param name="replace" />
		<xsl:choose>
			<xsl:when test="contains($subject, $pattern)">
				<xsl:value-of
					select="concat(substring-before($subject, $pattern), $replace)" />
				<xsl:call-template name="replace">
					<xsl:with-param name="subject"
						select="substring-after($subject, $pattern)" />
					<xsl:with-param name="pattern" select="$pattern" />
					<xsl:with-param name="replace" select="$replace" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$subject" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text"
						select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replaceDate">
		<xsl:param name="value" />
		<xsl:choose>
		  <xsl:when test="$value!=''">
			<xsl:choose>
		  		<xsl:when test="substring($value,1,4) > 2020">
					<xsl:text>2020-12-31T23:59:59Z</xsl:text>
				</xsl:when>
	 		    <xsl:otherwise>
		            <xsl:value-of select="$value" />
		  		</xsl:otherwise>
		    </xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
		     <xsl:value-of select="$value" />
		  </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>