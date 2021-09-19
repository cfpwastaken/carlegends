/*
[source]
Plane1=0,0,0, 640,0,0, 0,480,0, 1,1
Plane2=640,0,-640, 0,0,-640, 640,480,-640, 1,1
technique=Render

[destination]
Plane1= 0,0,-640, 0,0,0, 0,480,-640,  1,1
Plane2= 640,0,0, 640,0,-640, 640,480,0,  1,1
technique=Render

[solid]

[effect]
*/
//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------
float4x4 mWorldViewProj;  // World * View * Projection transformation
float fTime;			  // Time parameter. This keeps increasing


struct VS_OUTPUT
{
    float4 Position   : POSITION;  // vertex position 
    float4 Diffuse    : COLOR0;    // vertex diffuse color
    float2 Textcoord  : TEXCOORD0;
};


//-----------------------------------------------------------------------------

float4 RotateX( float4 pos,float v) {

    float fSin, fCos;   
    sincos( v, fSin, fCos );

	float4x4 rotMatrix;
	rotMatrix[0][0] = 1.0;
	rotMatrix[0][1] = 0.0;
	rotMatrix[0][2] = 0.0;
	rotMatrix[0][3] = 0.0;
	rotMatrix[1][0] = 0.0;
	rotMatrix[1][1] = fCos;
	rotMatrix[1][2] = -fSin;
	rotMatrix[1][3] = 0.0;
	rotMatrix[2][0] = 0.0;
	rotMatrix[2][1] = fSin;
	rotMatrix[2][2] = fCos;
	rotMatrix[2][3] = 0.0;
	rotMatrix[3][0] = 0.0;
	rotMatrix[3][1] = 0.0;
	rotMatrix[3][2] = 0.0;
	rotMatrix[3][3] = 1.0;

	return mul(rotMatrix, pos);
}

//-----------------------------------------------------------------------------

float4 RotateY( float4 pos,float v) {

    float fSin, fCos;   
    sincos( v, fSin, fCos );

	float4x4 rotMatrix;
	rotMatrix[0][0] = fCos;
	rotMatrix[0][1] = 0.0;
	rotMatrix[0][2] = fSin;
	rotMatrix[0][3] = 0.0;
	rotMatrix[1][0] = 0.0;
	rotMatrix[1][1] = 1.0;
	rotMatrix[1][2] = 0.0;
	rotMatrix[1][3] = 0.0;
	rotMatrix[2][0] = -fSin;
	rotMatrix[2][1] = 0.0;
	rotMatrix[2][2] = fCos;
	rotMatrix[2][3] = 0.0;
	rotMatrix[3][0] = 0.0;
	rotMatrix[3][1] = 0.0;
	rotMatrix[3][2] = 0.0;
	rotMatrix[3][3] = 1.0;

	return mul(rotMatrix, pos);
}


//-----------------------------------------------------------------------------

float4 RotateZ( float4 pos,float v) {

    float fSin, fCos;   
    sincos( v, fSin, fCos );

	float4x4 rotMatrix;
	rotMatrix[0][0] = fCos;
	rotMatrix[0][1] = -fSin;
	rotMatrix[0][2] = 0.0;
	rotMatrix[0][3] = 0.0;
	rotMatrix[1][0] = fSin;
	rotMatrix[1][1] = fCos;
	rotMatrix[1][2] = 0.0;
	rotMatrix[1][3] = 0.0;
	rotMatrix[2][0] = 0.0;
	rotMatrix[2][1] = 0.0;
	rotMatrix[2][2] = 1.0;
	rotMatrix[2][3] = 0.0;
	rotMatrix[3][0] = 0.0;
	rotMatrix[3][1] = 0.0;
	rotMatrix[3][2] = 0.0;
	rotMatrix[3][3] = 1.0;

	return mul(rotMatrix, pos);
}

//-----------------------------------------------------------------------------

VS_OUTPUT Main( 
    in float4 vPosition : POSITION,
	in float4 vColor : COLOR0,
    in float2 vTextcoord  : TEXCOORD0
 )
{
    VS_OUTPUT Output;

	float dz = 	0;
	float cz = 500;
	float v = 0;
	v = 3.14 *0.5 * fTime;
	dz = sin( 3.14 * fTime) *cz;
/*	
	if ( fTime < .2) {
		dz = cz*fTime / 0.2;
	}
	if ( fTime >= .2 && fTime <= .8) {
		dz = cz;
//		v = 3.14 / 2 * (fTime - 0.2) / 0.6;
	}
	if ( fTime > .8) {
		dz = cz * (1.0 - fTime) / 0.2;
//		v = 3.14 / 2;
	}
	*/
	vPosition = RotateY( vPosition - float4( 320,0,-320,0),v) + float4( 320,0,-320,0);
	vPosition = vPosition - float4( 0,0,dz,0);

    Output.Position = mul( vPosition, mWorldViewProj );

    // Output the diffuse color.
    Output.Diffuse = vColor;
    Output.Textcoord = vTextcoord;
    
    return Output;
}


technique Render
{
    pass P0
    {          
        VertexShader = compile vs_1_1 Main();
    }
}
