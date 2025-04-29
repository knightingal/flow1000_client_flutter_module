package com.example.flow1000_admin.bean

import com.google.gson.annotations.SerializedName

class ApkConfig (
     @SerializedName("applicationId")
     var applicationId: String,
     @SerializedName("versionCode")
     var versionCode: Long,
     @SerializedName("versionName")
     var versionName: String,
     @SerializedName("apkName")
     var apkName: String,
     @SerializedName("downloadUrl")
     var downloadUrl: String
)