// --------------------------------------------------------------------------------------------------------------------
// <copyright file="ConstantRotation.cs" company="Supyrb">
//   Copyright (c) 2017 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEngine;

namespace Supyrb
{
	public class ConstantRotation : MonoBehaviour
	{
		public enum UpdateType
		{
			DeltaTime,
			SmoothDeltaTime,
			UnscaledDeltaTime,
			Constant
		}

		[Tooltip("Rotating absolute in world space or relative to the axes of the object\n" +
				"For root objects use self, same effect but more performant.")]
		[SerializeField]
		private Space space = Space.World;

		[SerializeField]
		private Vector3 rotationAxis = Vector3.up;

		[Unit("seconds")]
		[SerializeField]
		private float degreePerSecond = 90f;

		[SerializeField]
		private UpdateType updateType = UpdateType.DeltaTime;

		[SerializeField]
		private bool updateQuaternionEveryFrame = true;
		
		[SerializeField]
		private bool onlyWhenVisible = false;

		[SerializeField]
		private bool rotateEveryFrame = true;

		private bool visible = false;
		private Quaternion rotationPerUpdate;

		private float deltaTime
		{
			get
			{
				switch (updateType)
				{
					case UpdateType.DeltaTime:
						return Time.deltaTime;
					case UpdateType.SmoothDeltaTime:
						return Time.smoothDeltaTime;
					case UpdateType.UnscaledDeltaTime:
						return Time.unscaledDeltaTime;
					case UpdateType.Constant:
						return 0.01666f;
					default:
						throw new ArgumentOutOfRangeException();
				}
			}
		}

		void Start()
		{
			if (!updateQuaternionEveryFrame)
			{
				updateType = UpdateType.Constant;
				CalculatePerFrameRotation();
			}
		}
		
		void OnEnable()
		{
			if (!visible && onlyWhenVisible)
			{
				this.enabled = false;
			}
		}

		void OnDisable()
		{
			visible = false;
		}

		public void SetRotateEveryFrame(bool rotate)
		{
			rotateEveryFrame = rotate;
		}
		
		private void OnBecameVisible()
		{
			visible = true;
			this.enabled = true;
		}

		private void OnBecameInvisible()
		{
			visible = false;
			if (onlyWhenVisible)
			{
				this.enabled = false;
			}
		}

		void LateUpdate()
		{
			if (!rotateEveryFrame)
			{
				return;
			}
			
			if(updateQuaternionEveryFrame) 
			{
				CalculatePerFrameRotation();
			}
			ApplyRotation();
		}

		private void ApplyRotation()
		{
			if (space == Space.World)
			{
				transform.rotation = rotationPerUpdate * transform.rotation;
			}
			else
			{
				transform.localRotation *= rotationPerUpdate;
			}
		}

		public void SetRotation(Vector3PairAsset euler)
		{
			if (space == Space.World)
			{
				transform.rotation = Quaternion.Euler(euler.A);
			}
			else
			{
				transform.localRotation = Quaternion.Euler(euler.A);
			}
		}
		
		public void CalculatePerFrameRotation()
		{
			CalculatePerFrameRotation(deltaTime);
		}

		public void CalculatePerFrameRotation(float time)
		{
			rotationPerUpdate = Quaternion.AngleAxis(degreePerSecond * time, rotationAxis);
		}

		public void UpdateRotation(float time)
		{
			CalculatePerFrameRotation(time);
			ApplyRotation();
		}
		
		public void SetRotationPerSecond(float rotationPerSecond)
		{
			degreePerSecond = rotationPerSecond;
		}

		public void SetXRotationAxis(float x)
		{
			rotationAxis.x = x;
		}

		public void SetYRotationAxis(float y)
		{
			rotationAxis.y = y;
		}

		public void SetZRotationAxis(float z)
		{
			rotationAxis.z = z;
		}

		#if UNITY_EDITOR
		void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.yellow;
			Gizmos.DrawRay(transform.position, (space == Space.Self) ? transform.rotation * rotationAxis.normalized : rotationAxis.normalized);
		}
		#endif
	}
}